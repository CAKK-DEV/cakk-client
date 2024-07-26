//
//  SocialLoginRepository.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import Combine

import Moya
import CombineMoya

import DomainUser

import Logger

public final class SocialLoginRepositoryImpl: SocialLoginRepository {
  
  // MARK: - Properties
  
  let provider: MoyaProvider<UserAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<UserAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Method
  
  public func signIn(credential: DomainUser.CredentialData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignInError> {
    Loggers.networkUser.info("로그인을 시도합니다.\nCredential: \(credential)", category: .network)
    
    return provider.requestPublisher(.signIn(credential: credential.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkUser.info("로그인에 성공하였습니다.", category: .network)
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.info("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toSocialLoginSignInError()
        } else {
          Loggers.networkUser.info("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toSocialLoginSignInError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func signUp(auth: DomainUser.AuthData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignUpError> {
    Loggers.networkUser.info("회원가입을 시도합니다.\nAuthData: \(auth)", category: .network)
    
    return provider.requestPublisher(.signUp(authRequest: auth.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkUser.info("회원가입에 성공하였습니다.", category: .network)
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.info("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toSocialLoginSignUpError()
        } else {
          Loggers.networkUser.info("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toSocialLoginSignUpError()
        }
      }
      .eraseToAnyPublisher()
  }
}
