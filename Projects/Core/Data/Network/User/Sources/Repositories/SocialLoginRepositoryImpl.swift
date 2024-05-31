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
  
  let provider: MoyaProvider<SocialLoginAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<SocialLoginAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Method
  
  public func signIn(credential: DomainUser.CredentialData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignInError> {
    return provider.requestPublisher(.signIn(credential: credential.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return response.data
        case 400, 500:
          let errorResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          throw NetworkError.customError(for: errorResponse.returnCode, message: errorResponse.returnMessage)
        default:
          throw NetworkError.unexpected(NSError(domain: "", code: response.statusCode, userInfo: nil))
        }
      }
      .decode(type: DomainUser.SocialLoginResponse.self, decoder: JSONDecoder())
      .mapError { error in
        if let networkError = error as? NetworkError {
          return networkError.toSocialLoginSignInError()
        } else {
          return NetworkError.error(for: error).toSocialLoginSignInError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func signUp(auth: DomainUser.AuthData) -> AnyPublisher<DomainUser.SocialLoginResponse, SocialLoginSignUpError> {
    provider.requestPublisher(.signUp(authRequest: auth.toDTO()))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return response.data
        case 400, 500:
          let errorResponse = try JSONDecoder().decode(SocialLoginResponseDTO.self, from: response.data)
          throw NetworkError.customError(for: errorResponse.returnCode, message: errorResponse.returnMessage)
        default:
          throw NetworkError.unexpected(NSError(domain: "", code: response.statusCode, userInfo: nil))
        }
      }
      .decode(type: DomainUser.SocialLoginResponse.self, decoder: JSONDecoder())
      .mapError { error in
        if let networkError = error as? NetworkError {
          return networkError.toSocialLoginSignUpError()
        } else {
          return NetworkError.error(for: error).toSocialLoginSignUpError()
        }
      }
      .eraseToAnyPublisher()
  }
}
