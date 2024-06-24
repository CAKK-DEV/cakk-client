//
//  BusinessRepositoryImpl.swift
//  NetworkBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusiness

import Moya
import CombineMoya

import SDWebImageWebPCoder

public final class BusinessRepositoryImpl: BusinessRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<BusinessAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<BusinessAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCertification(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, UploadCertificationError> {
    let businessRegistrationImagePublisher = uploadImage(image: businessRegistrationImage)
    let idCardImagePublisher = uploadImage(image: idCardImage)
    
    return businessRegistrationImagePublisher
      .combineLatest(idCardImagePublisher) /// 사업자 등록증, 신분증 이미지 업로드가 완료 되면 사장님 인증 요청을 보냅니다.
      .flatMap { [provider] businessRegistrationImageUrl, idCardImageUrl in
        provider.requestPublisher(.uploadCertification(
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
            let decodedResponse = try JSONDecoder().decode(UploadCertificationResponseDTO.self, from: response.data)
            throw BusinessNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
        }
        .mapError { error in
          if let networkError = error as? BusinessNetworkError {
            return networkError.toUploadCertificationError()
          } else {
            return BusinessNetworkError.error(for: error).toUploadCertificationError()
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  
  // MARK: - Private Methods
  
  /// PresignedUrl 요청 후 해당 url에 이미지를 업로드 한 후 imageUrl을 반환합니다.
  private func uploadImage(image: UIImage) -> AnyPublisher<String, UploadCertificationError> {
    provider.requestPublisher(.requestPresignedUrl)
      .tryMap { response -> (String, String) in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
          let presignedUrl = decodedResponse.data.presignedUrl
          let imageUrl = decodedResponse.data.imageUrl
          return (presignedUrl, imageUrl)
          
        default:
          throw UploadCertificationError.imageUploadFailure
        }
      }
      .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String, Error> in
        // TODO: - Webp로 변환하도록 변경
        guard let data = image.jpegData(compressionQuality: 1) else {
          return Fail(error: UploadCertificationError.imageUploadFailure).eraseToAnyPublisher()
        }
        /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//        guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//          return Fail(error: UploadCertificationError.imageUploadFailure).eraseToAnyPublisher()
//        }
        
        return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
        .map { _ in imageUrl }
        .mapError { _ in UploadCertificationError.imageUploadFailure }
        .eraseToAnyPublisher()
      }
      .mapError { _ in UploadCertificationError.failure }
      .eraseToAnyPublisher()
  }
}
