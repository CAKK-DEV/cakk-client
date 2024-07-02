//
//  MyShopIdUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser
import UserSession

public final class MyShopIdUseCaseImpl: MyShopIdUseCase {
  
  // MARK: - Properties
  
  private let repository: UserProfileRepository
  
  
  // MARK: - Initializers
  
  public init(repository: UserProfileRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<Int?, UserProfileError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.fetchMyCakeShopId(accessToken: accessToken)
    } else {
      Fail(error: DomainUser.UserProfileError.notSignedIn)
        .eraseToAnyPublisher()
    }
  }
}
