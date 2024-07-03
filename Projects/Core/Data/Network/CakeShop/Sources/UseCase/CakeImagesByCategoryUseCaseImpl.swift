//
//  CakeImagesByCategoryUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class CakeImagesByCategoryUseCaseImpl: CakeImagesByCategoryUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeImagesByCategoryRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeImagesByCategoryRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(category: CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    repository.fetch(category: category, count: count, lastCakeId: lastCakeId)
  }
}
