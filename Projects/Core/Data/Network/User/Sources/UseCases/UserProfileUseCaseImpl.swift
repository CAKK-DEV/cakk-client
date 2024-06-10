//
//  UserProfileUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class UserProfileUseCaseImpl: UserProfileUseCase {
  
  // MARK: - Properties
  
  private let repository: UserProfileRepository
  
  
  // MARK: - Initializers
  
  public init(repository: UserProfileRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<DomainUser.UserProfile, DomainUser.UserProfileError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.fetchUserProfile(accessToken: accessToken)
    } else {
      Fail(error: DomainUser.UserProfileError.notSignedIn)
        .eraseToAnyPublisher()
    }
  }
}
