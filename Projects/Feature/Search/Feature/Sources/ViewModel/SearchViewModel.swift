//
//  SearchViewModel.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainSearch

public final class SearchViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published private(set) var trendingSearchKeywords: [String] = []
  private let trendingSearchKeywordUseCase: TrendingSearchKeywordUseCase
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(trendingSearchKeywordUseCase: TrendingSearchKeywordUseCase) {
    self.trendingSearchKeywordUseCase = trendingSearchKeywordUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchTrendingSearchKeywords() {
    trendingSearchKeywordUseCase
      .execute(count: 10)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
      } receiveValue: { [weak self] keywords in
        self?.trendingSearchKeywords = keywords
      }
      .store(in: &cancellables)
  }
  
  
  // MARK: - Private Methods
}
