//
//  CakeImageDetailUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public final class CakeImageDetailUseCaseImpl: CakeImageDetailUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeImageId: Int) -> AnyPublisher<CakeImageDetail, CakeShopError> {
    repository.fetchImageDetail(cakeImageId: cakeImageId)
  }
}
