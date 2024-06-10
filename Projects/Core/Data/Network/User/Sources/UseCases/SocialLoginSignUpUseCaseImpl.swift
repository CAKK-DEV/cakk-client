//
//  SocialLoginSignUpUseCaseImpl.swift
//  CAKK
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import Combine
import Moya

import DomainUser
import DomainOAuthToken

import UserSession

public final class SocialLoginSignUpUseCaseImpl: SocialLoginSignUpUseCase {
  
  // MARK: - Properties
  
  private let socialLoginRepository: SocialLoginRepository
  
  
  // MARK: - Initializers
  
  public init(socialLoginRepository: SocialLoginRepository) {
    self.socialLoginRepository = socialLoginRepository
  }
  
  
  // MARK: - Execution
  
  public func execute(credential: CredentialData, userData: UserData) -> AnyPublisher<Void, SocialLoginSignUpError> {
    let auth = AuthData(
      provider: credential.loginProvider,
      idToken: credential.idToken,
      nickname: userData.nickname,
      email: userData.email,
      birthday: userData.birthday,
      gender: userData.gender)
    
    return socialLoginRepository.signUp(auth: auth)
      .handleEvents(receiveOutput: { response in
        // 로그인 성공 후 결과값으로 받은 토큰들 저장
        UserSession.shared.update(accessToken: response.accessToken)
        UserSession.shared.update(refreshToken: response.refreshToken)
        UserSession.shared.update(signInState: true)
        UserSession.shared.update(loginProvider: credential.loginProvider)
      })
      .map { _ in () }
      .eraseToAnyPublisher()
  }
}
