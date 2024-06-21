//
//  MockUserProfileUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockUserProfileUseCase: UserProfileUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let role: UserRole
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 1,
    role: UserRole
  ) {
    self.delay = delay
    self.role = role
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<DomainUser.UserProfile, DomainUser.UserProfileError> {
    return Just(UserProfile.makeMockUserProfile(role: role))
      .delay(for: .seconds(delay), scheduler: RunLoop.main)
      .setFailureType(to: UserProfileError.self)
      .eraseToAnyPublisher()
  }
}

