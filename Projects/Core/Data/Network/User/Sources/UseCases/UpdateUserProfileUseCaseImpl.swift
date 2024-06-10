//
//  UpdateProfileUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class UpdateUserProfileUseCaseImpl: UpdateUserProfileUseCase {
  
  // MARK: - Properties
  
  private let repository: UserProfileRepository
  
  
  // MARK: - Initializers
  
  public init(repository: UserProfileRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(newUserProfile: DomainUser.NewUserProfile) -> AnyPublisher<Void, UserProfileError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.updateUserProfile(newUserProfile: newUserProfile, accessToken: accessToken)
    } else {
      return Fail(error: UserProfileError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
