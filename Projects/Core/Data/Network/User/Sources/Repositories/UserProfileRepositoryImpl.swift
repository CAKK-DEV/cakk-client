//
//  UserProfileRepository.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
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
            throw CAKKError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return data.toDomain()
          
        default:
          throw CAKKError.unexpected(NSError(domain: "UserProfile", code: response.statusCode))
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func updateUserProfile(newUserProfile: DomainUser.NewUserProfile, accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    provider.requestPublisher(.updateUserProfile(newUserProfile: newUserProfile.toDTO(), accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(UpdateUserProfileResponseDTO.self, from: response.data)
          if decodedResponse.returnCode != "1000" {
            throw CAKKError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return Void()
          
        default:
          throw CAKKError.unexpected(NSError(domain: "UserProfile", code: response.statusCode))
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKError.error(for: error).toUserProfileError()
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
            throw CAKKError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return Void()
          
        default:
          throw CAKKError.unexpected(NSError(domain: "UserProfile", code: response.statusCode))
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKError {
          return cakkError.toUserProfileError()
        } else {
          return CAKKError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
}
