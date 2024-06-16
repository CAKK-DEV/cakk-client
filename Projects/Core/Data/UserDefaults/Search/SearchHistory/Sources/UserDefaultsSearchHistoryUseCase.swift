//
//  UserDefaultsSearchHistoryUseCase.swift
//  UserDefaultsSearchHistory
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class UserDefaultsSearchHistoryUseCase: SearchHistoryUseCase {
  
  // MARK: - Properties
  
  private let storageKey = "searchHistories"
  private let userDefaults: UserDefaults
  private var cachedSearchHistories: [SearchHistory] = []
  
  
  // MARK: - Initializers
  
  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    self.cachedSearchHistories = self.loadSearchHistories()
  }
  
  // MARK: - Public Methods
  
  public func fetchSearchHistories() -> AnyPublisher<[SearchHistory], Error> {
    return Just(cachedSearchHistories.sorted(by: { $0.date < $1.date }))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  public func addSearchHistory(keyword: String) -> AnyPublisher<Void, Error> {
    if let index = cachedSearchHistories.firstIndex(where: { $0.keyword == keyword }) {
      cachedSearchHistories[index].date = Date()
    } else {
      cachedSearchHistories.append(SearchHistory(keyword: keyword))
    }
    
    cachedSearchHistories.sort(by: { $0.date < $1.date })
    
    return saveSearchHistories(cachedSearchHistories)
  }
  
  public func removeSearchHistory(history: SearchHistory) -> AnyPublisher<Void, Error> {
    cachedSearchHistories.removeAll { $0.id == history.id }
    return saveSearchHistories(cachedSearchHistories)
  }
  
  public func clearSearchHistories() -> AnyPublisher<Void, Error> {
    cachedSearchHistories.removeAll()
    userDefaults.removeObject(forKey: storageKey)
    return Just(())
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  
  // MARK: - Private Methods
  
  private func loadSearchHistories() -> [SearchHistory] {
    guard let data = userDefaults.data(forKey: storageKey),
          let histories = try? JSONDecoder().decode([SearchHistory].self, from: data) else {
      return []
    }
    return histories
  }
  
  private func saveSearchHistories(_ histories: [SearchHistory]) -> AnyPublisher<Void, Error> {
    return Future { promise in
      do {
        let data = try JSONEncoder().encode(histories)
        self.userDefaults.set(data, forKey: self.storageKey)
        promise(.success(()))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
}
