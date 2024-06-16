//
//  MockSearchHistoryUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class MockSearchHistoryUseCase: SearchHistoryUseCase {
  
  // MARK: - Properties
  
  private var searchHistories: [SearchHistory] = [
    .init(keyword: "검색기록1", date: Date(timeIntervalSinceNow: -1000)),
    .init(keyword: "검색기록2", date: Date(timeIntervalSinceNow: -2000)),
    .init(keyword: "검색기록3", date: Date(timeIntervalSinceNow: -3000)),
    .init(keyword: "검색기록4", date: Date(timeIntervalSinceNow: -4000)),
    .init(keyword: "검색기록5", date: Date(timeIntervalSinceNow: -5000))
  ]
  
  private let delay: TimeInterval
  

  // MARK: - Initializers
  
  public init(delay: TimeInterval = 1) {
    self.delay = delay
  }
  
  
  // MARK: - Public Methods
  
  public func fetchSearchHistories() -> AnyPublisher<[DomainSearch.SearchHistory], any Error> {
    Just(searchHistories)
      .delay(for: .seconds(delay), scheduler: RunLoop.main)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  public func addSearchHistory(keyword: String) -> AnyPublisher<Void, any Error> {
    if let index = searchHistories.firstIndex(where: { $0.keyword == keyword }) {
      searchHistories[index].date = Date()
    } else {
      searchHistories.append(SearchHistory(keyword: keyword))
    }
    
    return Just(Void())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  public func removeSearchHistory(history: DomainSearch.SearchHistory) -> AnyPublisher<Void, any Error> {
    if let index = searchHistories.firstIndex(of: history) {
      searchHistories.remove(at: index)
    }
    
    return Just(Void())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  public func clearSearchHistories() -> AnyPublisher<Void, any Error> {
    searchHistories.removeAll()
    
    return Just(Void())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
