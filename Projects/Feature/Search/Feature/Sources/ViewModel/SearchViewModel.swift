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
  
  @Published private(set) var cakeImages: [CakeImage] = []
  private let searchCakeImagesUseCase: SearchCakeImagesUseCase
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case success
    case failure
    case loadMoreFailure
  }
  
  @Published var searchKeyword: String = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    trendingSearchKeywordUseCase: TrendingSearchKeywordUseCase,
    searchCakeImagesUseCase: SearchCakeImagesUseCase
  ) {
    self.trendingSearchKeywordUseCase = trendingSearchKeywordUseCase
    self.searchCakeImagesUseCase = searchCakeImagesUseCase
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
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    
    searchCakeImagesUseCase
      .execute(keyword: searchKeyword,
               latitude: 37.4979,
               longitude: 127.0276,
               pageSize: 10,
               lastCakeId: cakeImages.last?.id)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.imageFetchingState = .failure
        } else {
          self?.imageFetchingState = .success
        }
      } receiveValue: { [weak self] cakeImages in
        self?.cakeImages = cakeImages
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loading
    
    if let lastCakeId = cakeImages.last?.id {
      searchCakeImagesUseCase.execute(keyword: searchKeyword,
                                      latitude: 37.4979,
                                      longitude: 127.0276,
                                      pageSize: 10,
                                      lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .loadMoreFailure
            print(error)
          } else {
            self?.imageFetchingState = .idle
          }
        } receiveValue: { [weak self] value in
          self?.cakeImages.append(contentsOf: value)
        }
        .store(in: &cancellables)
    }
  }
  
  // MARK: - Private Methods
}
