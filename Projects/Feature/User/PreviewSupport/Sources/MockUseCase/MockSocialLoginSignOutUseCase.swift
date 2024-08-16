//
//  MockSocialLoginSignOutUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 8/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockSocialLoginSignOutUseCase: SocialLoginSignOutUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  private let scenario: Scenario
  public enum Scenario {
    case success
    case failure
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
  
  public func execute() -> AnyPublisher<Void, any Error> {
    switch scenario {
    case .failure:
      Fail(error: NSError(domain: "PreviewSupport", code: -1))
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
      
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }
}
