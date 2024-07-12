//
//  TrendingCakeShopsUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainSearch

public final class TrendingCakeShopsUseCaseImpl: TrendingCakeShopsUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<[CakeShop], any Error> {
    repository.fetchTrendingCakeShops(count: 10)
  }
}
