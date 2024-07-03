//
//  DeleteCakeImageUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainCakeShop
import UserSession

public final class DeleteCakeImageUseCaseImpl: DeleteCakeImageUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeImageId: Int) -> AnyPublisher<Void, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.deleteCakeImage(cakeImageId: cakeImageId, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
