//
//  UserProfileRepository.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainUser

import Moya
import CombineMoya

import SDWebImageWebPCoder

public final class UserProfileRepositoryImpl: UserProfileRepository {
  
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<UserAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<UserAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchUserProfile(accessToken: String) -> AnyPublisher<DomainUser.UserProfile, DomainUser.UserProfileError> {
    provider.requestPublisher(.fetchUserProfile(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(UserProfileResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(UserProfileResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func updateUserProfile(newUserProfile: DomainUser.NewUserProfile, accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    uploadProfileImageIfNeeded(image: newUserProfile.profileImage)
      .flatMap { [provider] profileImageUrl -> AnyPublisher<Response, UserProfileError> in
        provider.requestPublisher(.updateUserProfile(newUserProfile: newUserProfile.toDTO(profileImageUrl: profileImageUrl), accessToken: accessToken))
          .mapError { _ in UserProfileError.failure }
          .eraseToAnyPublisher()
      }
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(UpdateUserProfileResponseDTO.self, from: response.data)
          if decodedResponse.returnCode != "1000" {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(UpdateUserProfileResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func withdraw(accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    provider.requestPublisher(.withdraw(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data)
          if decodedResponse.returnCode != "1000" {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, UserProfileError> {
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
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
        }
        .mapError { error in
          if let networkError = error as? CAKKUserNetworkError {
            return networkError.toUserProfileError()
          } else {
            return CAKKUserNetworkError.error(for: error).toUserProfileError()
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  // MARK: - Private Methods
  
  private func uploadProfileImageIfNeeded(image: NewUserProfile.ProfileImage) -> AnyPublisher<String?, UserProfileError> {
    switch image {
    case .delete, .none:
      return Just(nil)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
      
    case .original(let originalImageUrl):
      return Just(originalImageUrl)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
      
    case .new(let image):
      return provider.requestPublisher(.requestPresignedUrl)
        .tryMap { response -> (String, String) in
          switch response.statusCode {
          case 200..<300:
            let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
            let presignedUrl = decodedResponse.data.presignedUrl
            let imageUrl = decodedResponse.data.imageUrl
            return (presignedUrl, imageUrl)
            
          default:
            throw UserProfileError.imageUploadFailure
          }
        }
        .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String?, Error> in
          // TODO: - 이미지 Webp로 변환
          guard let data = image.jpegData(compressionQuality: 1) else {
            return Fail(error: UserProfileError.imageUploadFailure).eraseToAnyPublisher()
          }
          /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//          SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//          guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//            return Fail(error: UserProfileError.imageUploadFailure).eraseToAnyPublisher()
//          }
          
          return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
          .map { _ in imageUrl }
          .mapError { _ in UserProfileError.imageUploadFailure }
          .eraseToAnyPublisher()
        }
        .mapError { _ in UserProfileError.imageUploadFailure }
        .eraseToAnyPublisher()
    }
  }
  
  /// PresignedUrl 요청 후 해당 url에 이미지를 업로드 한 후 imageUrl을 반환합니다.
  private func uploadImage(image: UIImage) -> AnyPublisher<String, UserProfileError> {
    provider.requestPublisher(.requestPresignedUrl)
      .tryMap { response -> (String, String) in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
          let presignedUrl = decodedResponse.data.presignedUrl
          let imageUrl = decodedResponse.data.imageUrl
          return (presignedUrl, imageUrl)
          
        default:
          throw UserProfileError.imageUploadFailure
        }
      }
      .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String, Error> in
        // TODO: - Webp로 변환하도록 변경
        guard let data = image.jpegData(compressionQuality: 1) else {
          return Fail(error: UserProfileError.imageUploadFailure).eraseToAnyPublisher()
        }
        /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//        guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//          return Fail(error: UploadCertificationError.imageUploadFailure).eraseToAnyPublisher()
//        }
        
        return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
        .map { _ in imageUrl }
        .mapError { _ in UserProfileError.imageUploadFailure }
        .eraseToAnyPublisher()
      }
      .mapError { _ in UserProfileError.failure }
      .eraseToAnyPublisher()
  }
}
