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
  
  public func updateUserProfile(profileImageUrl: String?, nickName: String, email: String, gender: DomainUser.Gender, birthday: Date?, accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    let newUserProfileDTO = NewUserProfileDTO(profileImageUrl: profileImageUrl,
                                              nickname: nickName,
                                              email: email,
                                              gender: gender.toDTO(),
                                              birthday: birthday?.toDTO())
    return provider.requestPublisher(.updateUserProfile(newUserProfile: newUserProfileDTO, accessToken: accessToken))
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
  
  public func fetchMyCakeShopId(accessToken: String) -> AnyPublisher<Int?, UserProfileError> {
    provider.requestPublisher(.fetchMyShopId(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(MyShopResponseDTO.self, from: response.data)
          return decodedResponse.data?.cakeShopId
          
        default:
          let decodedResponse = try JSONDecoder().decode(MyShopResponseDTO.self, from: response.data)
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
}
