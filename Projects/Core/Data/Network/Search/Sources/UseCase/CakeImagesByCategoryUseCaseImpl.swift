//
//  CakeImagesByCategoryUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainSearch

public final class CakeImagesByCategoryUseCaseImpl: CakeImagesByCategoryUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(category: CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    repository.fetchCakeImages(category: category, count: count, lastCakeId: lastCakeId)
  }
}
