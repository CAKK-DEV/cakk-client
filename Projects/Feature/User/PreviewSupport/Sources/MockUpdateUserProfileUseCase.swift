//
//  MockUpdateUserProfileUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockUpdateUserProfileUseCase: UpdateUserProfileUseCase {
  
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
  
  public func execute(newUserProfile: DomainUser.NewUserProfile) -> AnyPublisher<Void, DomainUser.UserProfileError> {
    switch scenario {
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
    case .failure:
      Fail(error: UserProfileError.failure)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  }
}
