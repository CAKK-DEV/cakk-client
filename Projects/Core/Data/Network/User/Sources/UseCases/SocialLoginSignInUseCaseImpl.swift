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

import UserSession

public final class SocialLoginSignInUseCaseImpl: SocialLoginSignInUseCase {
  
  // MARK: - Repository
  
  private let repository: SocialLoginRepository
  
  
  // MARK: - Initializers
  
  public init(socialLoginRepository: SocialLoginRepository) {
    self.repository = socialLoginRepository
  }
  

  // MARK: - Execution
  
  public func execute(credential: CredentialData) -> AnyPublisher<Void, SocialLoginSignInError> {
    repository.signIn(credential: credential)
      .handleEvents(receiveOutput: { response in
        // 로그인 성공 후 결과값으로 받은 토큰들 저장
        UserSession.shared.update(accessToken: response.accessToken)
        UserSession.shared.update(refreshToken: response.refreshToken)
        UserSession.shared.update(signInState: true)
        UserSession.shared.update(loginProvider: credential.loginProvider)
      })
      .map { _ in }
      .eraseToAnyPublisher()
  }
}
