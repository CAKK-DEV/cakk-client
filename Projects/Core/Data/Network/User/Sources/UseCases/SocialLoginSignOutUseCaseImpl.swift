//
//  SocialLoginSignOutUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 8/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser
import DomainOAuthToken

import UserSession

public final class SocialLoginSignOutUseCaseImpl: SocialLoginSignOutUseCase {
  
  // MARK: - Properties
  
  private let repository: SocialLoginRepository
  
  
  // MARK: - Initializers
  
  public init(socialLoginRepository: SocialLoginRepository) {
    self.repository = socialLoginRepository
  }
  
  public func execute() -> AnyPublisher<Void, any Error> {
    if let accessToken = UserSession.shared.accessToken,
          let refreshToken = UserSession.shared.accessToken {
      repository.signOut(accessToken: accessToken, refreshToken: refreshToken)
        .eraseToAnyPublisher()
    } else {
      Fail(error: NSError(domain: "Tokens not found", code: -1))
        .eraseToAnyPublisher()
    }
  }
}
