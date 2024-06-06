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

public final class SocialLoginSignUpUseCaseImpl: SocialLoginSignUpUseCase {
  
  // MARK: - Properties
  
  private let socialLoginRepository: SocialLoginRepository
  private let userSession: UserSession
  
  
  // MARK: - Initializers
  
  public init(
    socialLoginRepository: SocialLoginRepository,
    userSession: UserSession) 
  {
    self.socialLoginRepository = socialLoginRepository
    self.userSession = userSession
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
      .handleEvents(receiveOutput: { [weak self] response in
        // 로그인 성공 후 결과값으로 받은 토큰들 저장
        self?.userSession.update(accessToken: response.accessToken)
        self?.userSession.update(refreshToken: response.accessToken)
      })
      .map { _ in () }
      .eraseToAnyPublisher()
  }
}
