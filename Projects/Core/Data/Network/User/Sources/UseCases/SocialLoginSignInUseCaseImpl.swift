//
//  SocialLoginSignInUseCaseImpl.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import Combine

import DomainUser
import DomainOAuthToken

public final class SocialLoginSignInUseCaseImpl: SocialLoginSignInUseCase {
  
  // MARK: - Repository
  
  private let repository: SocialLoginRepository
  private let oauthTokenRepository: OAuthTokenRepository
  
  
  // MARK: - Initializers
  
  public init(socialLoginRepository: SocialLoginRepository,
              oauthTokenRepository: OAuthTokenRepository) {
    self.repository = socialLoginRepository
    self.oauthTokenRepository = oauthTokenRepository
  }
  

  // MARK: - Execution
  
  public func execute(credential: CredentialData) -> AnyPublisher<Void, SocialLoginSignInError> {
    repository.signIn(credential: credential)
      .handleEvents(receiveOutput: { [weak self] response in
        // 로그인 성공 후 결과값으로 받은 토큰들 저장
        self?.oauthTokenRepository.saveAccessToken(response.accessToken)
        self?.oauthTokenRepository.saveRefreshToken(response.refreshToken)
      })
      .map { _ in }
      .eraseToAnyPublisher()
  }
}
