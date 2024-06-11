//
//  WithdrawUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class WithdrawUseCaseImpl: WithdrawUseCase {
  
  // MARK: - Properties
  
  private let repository: UserProfileRepository
  
  
  // MARK: - Initializers
  
  public init(repository: UserProfileRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<Void, UserProfileError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.withdraw(accessToken: accessToken)
    } else {
      Fail(error: DomainUser.UserProfileError.notSignedIn)
        .eraseToAnyPublisher()
    }
  }
}
