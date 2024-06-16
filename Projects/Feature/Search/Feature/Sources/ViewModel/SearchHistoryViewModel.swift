//
//  SearchHistoryViewModel.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainSearch

public final class SearchHistoryViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published private(set) var searchHistories: [SearchHistory] = []
  private let searchHistoryUseCase: SearchHistoryUseCase
  @Published private(set) var searchHistoryFetchingState: SearchHistoryFetchingState = .idle
  enum SearchHistoryFetchingState {
    case idle
    case loading
    case completed
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(searchHistoryUseCase: SearchHistoryUseCase) {
    self.searchHistoryUseCase = searchHistoryUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchSearchHistory() {
    searchHistoryFetchingState = .loading
    
    searchHistoryUseCase.fetchSearchHistories()
      .sink { [weak self] completion in
        self?.searchHistoryFetchingState = .completed
      } receiveValue: { [weak self] searchHistories in
        self?.searchHistories = searchHistories
          .sorted(by: { $0.date > $1.date })
      }
      .store(in: &cancellables)
  }
  
  public func addSearchHistory(searchKeyword: String) {
    searchHistoryUseCase.addSearchHistory(keyword: searchKeyword)
      .sink { [weak self] _ in
        guard let self else { return }
        
        /// 로컬로 검색 기록을 즉시 업데이트 해줍니다.
        if let index = searchHistories.firstIndex(where: { $0.keyword == searchKeyword }) {
          searchHistories[index].date = Date()
        } else {
          searchHistories.insert(.init(keyword: searchKeyword), at: 0)
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func removeSearchHistory(_ item: SearchHistory) {
    searchHistoryUseCase.removeSearchHistory(history: item)
      .sink { [weak self] completion in
        /// 로컬로 검색 기록을 즉시 삭제 합니다.
        if let index = self?.searchHistories.firstIndex(of: item) {
          self?.searchHistories.remove(at: index)
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
}
