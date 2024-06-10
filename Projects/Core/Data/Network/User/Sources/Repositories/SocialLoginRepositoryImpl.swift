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

public final class SocialLoginRepositoryImpl: SocialLoginRepository {
  
  // MARK: - Properties
  
  let provider: MoyaProvider<UserAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<UserAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Method
  
  public func signIn(credential: DomainUser.CredentialData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignInError> {
    return provider.requestPublisher(.signIn(credential: credential.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          return data.toDomain()
        default:
          throw CAKKError.unexpected(NSError(domain: "SocialLoginAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKError {
          return networkError.toSocialLoginSignInError()
        } else {
          return CAKKError.error(for: error).toSocialLoginSignInError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func signUp(auth: DomainUser.AuthData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignUpError> {
    provider.requestPublisher(.signUp(authRequest: auth.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CAKKError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          return data.toDomain()
        default:
          throw CAKKError.unexpected(NSError(domain: "SocialLoginAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKError {
          return networkError.toSocialLoginSignUpError()
        } else {
          return CAKKError.error(for: error).toSocialLoginSignUpError()
        }
      }
      .eraseToAnyPublisher()
  }
}
