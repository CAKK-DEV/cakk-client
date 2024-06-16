//
//  SearchHistoryUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchHistoryUseCase {
  func fetchSearchHistories() -> AnyPublisher<[SearchHistory], Error>
  func addSearchHistory(keyword: String) -> AnyPublisher<Void, Error>
  func removeSearchHistory(history: SearchHistory) -> AnyPublisher<Void, Error>
  func clearSearchHistories() -> AnyPublisher<Void, Error>
}
