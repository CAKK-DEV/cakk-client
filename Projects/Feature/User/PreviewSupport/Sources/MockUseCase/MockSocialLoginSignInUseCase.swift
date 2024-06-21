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

public struct MockSocialLoginSignInUseCase: SocialLoginSignInUseCase {
  private let delay: TimeInterval
  
  public init(delay: TimeInterval = 1.0) {
    self.delay = delay
  }
  
  public func execute(credential: DomainUser.CredentialData) -> AnyPublisher<Void, DomainUser.SocialLoginSignInError> {
    return Just(())
      .delay(for: .seconds(delay), scheduler: RunLoop.main)
      .setFailureType(to: DomainUser.SocialLoginSignInError.self)
      .eraseToAnyPublisher()
  }
}
