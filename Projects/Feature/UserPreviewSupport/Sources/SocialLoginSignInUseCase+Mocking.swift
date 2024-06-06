//
//  A.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/6/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

struct MockSocialLoginSignUseCase: SocialLoginSignInUseCase {
  public func execute(credential: DomainUser.CredentialData) -> AnyPublisher<Void, DomainUser.SocialLoginSignInError> {
    return Just(())
      .delay(for: 1, scheduler: RunLoop.main)
      .setFailureType(to: DomainUser.SocialLoginSignInError.self)
      .eraseToAnyPublisher()
  }
}

public extension SocialLoginSignInUseCase {
  static var mock: SocialLoginSignInUseCase {
    return MockSocialLoginSignUseCase()
  }
}
