//
//  MockWithdrawUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockWithdrawUseCase: WithdrawUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  private let scenario: Scenario
  public enum Scenario {
    case success
    case serverError
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
  
  public func execute() -> AnyPublisher<Void, UserProfileError> {
    switch scenario {
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
      
    case .serverError:
      Fail(error: UserProfileError.serverError)
        .eraseToAnyPublisher()
    }
  }
}
