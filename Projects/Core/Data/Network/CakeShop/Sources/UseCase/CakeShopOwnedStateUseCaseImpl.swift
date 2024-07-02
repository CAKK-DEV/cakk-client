//
//  CakeShopOwnedStateUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import UserSession

public final class CakeShopOwnedStateUseCaseImpl: CakeShopOwnedStateUseCase {
 
  // MARK: - Properties
  
  private let repository: CakeShopDetailRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopDetailRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int) -> AnyPublisher<Bool, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.isOwned(shopId: shopId, accessToken: accessToken)
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
