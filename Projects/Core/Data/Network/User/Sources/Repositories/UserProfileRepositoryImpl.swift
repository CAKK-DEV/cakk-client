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
  
  // MARK: - Private Methods
  
  private func uploadProfileImageIfNeeded(image: NewUserProfile.ProfileImage) -> AnyPublisher<String?, UserProfileError> {
    switch image {
    case .delete, .none:
      return Just(nil)
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
          guard let pngData = image.pngData() else {
            return Fail(error: UserProfileError.imageUploadFailure).eraseToAnyPublisher()
          }
          return provider.requestPublisher(.uploadProfileImage(presignedUrl: presignedUrl, image: pngData))
            .map { _ in imageUrl }
            .mapError { _ in UserProfileError.imageUploadFailure }
            .eraseToAnyPublisher()
        }
        .mapError { _ in UserProfileError.imageUploadFailure }
        .eraseToAnyPublisher()
    }
  }
}
