//
//  TrendingSearchKeywordUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class TrendingSearchKeywordUseCaseImpl: TrendingSearchKeywordUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(count: Int) -> AnyPublisher<[String], any Error> {
    repository.fetchTrendingSearchKeywords(count: count)
  }
}
