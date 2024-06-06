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
  private let userSession: UserSession
  
  
  // MARK: - Initializers
  
  public init(socialLoginRepository: SocialLoginRepository,
              userSession: UserSession) {
    self.repository = socialLoginRepository
    self.userSession = userSession
  }
  

  // MARK: - Execution
  
  public func execute(credential: CredentialData) -> AnyPublisher<Void, SocialLoginSignInError> {
    repository.signIn(credential: credential)
      .handleEvents(receiveOutput: { [weak self] response in
        // 로그인 성공 후 결과값으로 받은 토큰들 저장
        self?.userSession.update(accessToken: response.accessToken)
        self?.userSession.update(refreshToken: response.accessToken)
      })
      .map { _ in }
      .eraseToAnyPublisher()
  }
}
