//
//  MockTrendingSearchKeywordUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public struct MockTrendingSearchKeywordUseCase: TrendingSearchKeywordUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  
  // MARK: - Initializers
  
  public init(delay: TimeInterval = 1) {
    self.delay = delay
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<[String], any Error> {
    Just([
        "인기 검색어1",
        "인기 검색어2",
        "인기 검색어3",
        "인기 검색어4",
        "인기 검색어5",
        "인기 검색어6",
        "인기 검색어7",
        "인기 검색어8",
        "인기 검색어9",
        "인기 검색어10"
    ])
    .delay(for: .seconds(delay), scheduler: RunLoop.main)
    .setFailureType(to: Error.self)
    .eraseToAnyPublisher()
  }
}
