//
//  MockConfirmVerificationCodeUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockConfirmVerificationCodeUseCase: ConfirmVerificationCodeUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  private let scenario: Scenario
  public enum Scenario {
    case failure
    case success
  }
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 1,
    scenario: Scenario = .success
  ) {
    self.delay = delay
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func confirmVerificationCode(email: String, code: String) -> AnyPublisher<Void, EmailVerificationError> {
    switch scenario {
    case .failure:
      Fail(error: EmailVerificationError.failure)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
      
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: EmailVerificationError.self)
        .eraseToAnyPublisher()
    }
  }
}
