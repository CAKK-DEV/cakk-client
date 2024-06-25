//
//  BusinessOwnerRepositoryImpl.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import Moya
import CombineMoya

import DomainBusinessOwner

public class BusinessOwnerRepositoryImpl: BusinessOwnerRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<BusinessOwnerAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<BusinessOwnerAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  
  public func requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, BusinessOwnerError> {
    let businessRegistrationImagePublisher = uploadImage(image: businessRegistrationImage)
    let idCardImagePublisher = uploadImage(image: idCardImage)
    
    return businessRegistrationImagePublisher
      .combineLatest(idCardImagePublisher) /// 사업자 등록증, 신분증 이미지 업로드가 완료 되면 사장님 인증 요청을 보냅니다.
      .flatMap { [provider] businessRegistrationImageUrl, idCardImageUrl in
        provider.requestPublisher(.requestCakeShopOwnerVerification(
          shopId: shopId,
          businessRegistrationImageUrl: businessRegistrationImageUrl,
          idCardImageUrl: idCardImageUrl,
          contact: contact,
          message: message,
          accessToken: accessToken)
        )
        .tryMap { response in
          switch response.statusCode {
          case 200..<300:
            return Void()
            
          default:
            let decodedResponse = try JSONDecoder().decode(OwnerVerificationResponseDTO.self, from: response.data)
            throw BusinessOwnerNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
        }
        .mapError { error in
          if let networkError = error as? BusinessOwnerNetworkError {
            return networkError.toBusinessOwnerError()
          } else {
            return BusinessOwnerNetworkError.error(for: error).toBusinessOwnerError()
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  /// PresignedUrl 요청 후 해당 url에 이미지를 업로드 한 후 imageUrl을 반환합니다.
  private func uploadImage(image: UIImage) -> AnyPublisher<String, BusinessOwnerError> {
    provider.requestPublisher(.requestPresignedUrl)
      .tryMap { response -> (String, String) in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
          let presignedUrl = decodedResponse.data.presignedUrl
          let imageUrl = decodedResponse.data.imageUrl
          return (presignedUrl, imageUrl)
          
        default:
          throw BusinessOwnerError.imageUploadFailure
        }
      }
      .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String, Error> in
        guard let data = image.jpegData(compressionQuality: 1) else {
          return Fail(error: BusinessOwnerError.imageUploadFailure).eraseToAnyPublisher()
        }
        
        return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
        .map { _ in imageUrl }
        .mapError { _ in BusinessOwnerError.imageUploadFailure }
        .eraseToAnyPublisher()
      }
      .mapError { _ in BusinessOwnerError.failure }
      .eraseToAnyPublisher()
  }
}
