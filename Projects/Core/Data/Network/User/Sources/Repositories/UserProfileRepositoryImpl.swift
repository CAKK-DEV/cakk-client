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

import Logger

public final class UserProfileRepositoryImpl: UserProfileRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<UserAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<UserAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchUserProfile(accessToken: String) -> AnyPublisher<DomainUser.UserProfile, DomainUser.UserProfileError> {
    Loggers.networkUser.info("유저 정보를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.fetchUserProfile(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(UserProfileResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkUser.info("유저 정보를 가져오는데 성공하였습니다.\n\(data)", category: .network)
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(UserProfileResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(cakkError.localizedDescription)", category: .network)
          return cakkError.toUserProfileError()
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func updateUserProfile(profileImageUrl: String?, nickName: String, email: String, gender: DomainUser.Gender, birthday: Date?, accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    Loggers.networkUser.info("\(nickName)의 프로필을 업데이트 합니다.", category: .network)
    
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
          
          Loggers.networkUser.info("\(nickName)의 프로필을 업데이트에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(UpdateUserProfileResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(cakkError.localizedDescription)", category: .network)
          return cakkError.toUserProfileError()
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func withdraw(accessToken: String) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    Loggers.networkUser.info("회원 탈퇴를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.withdraw(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data)
          if decodedResponse.returnCode != "1000" {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkUser.info("회원 탈퇴에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(WithdrawResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(cakkError.localizedDescription)", category: .network)
          return cakkError.toUserProfileError()
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchMyCakeShopId(accessToken: String) -> AnyPublisher<Int?, UserProfileError> {
    Loggers.networkUser.info("나의 케이크샵 아이디를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.fetchMyShopId(accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(MyShopResponseDTO.self, from: response.data)
          
          Loggers.networkUser.info("나의 케이크샵 아이디를 불러오는데 성공하였습니다.\n\(decodedResponse.data == nil ? "소유하고있는 케이크샵이 없습니다." : "내 케이크샵 아이디: \(decodedResponse.data!.cakeShopId ?? -1)")", category: .network)
          return decodedResponse.data?.cakeShopId
          
        default:
          let decodedResponse = try JSONDecoder().decode(MyShopResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let cakkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(cakkError.localizedDescription)", category: .network)
          return cakkError.toUserProfileError()
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toUserProfileError()
        }
      }
      .eraseToAnyPublisher()
  }
}
