//
//  SearchViewModel.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import CommonDomain
import DomainSearch

import LocationService

public final class SearchViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published private(set) var trendingSearchKeywords: [String] = []
  private let trendingSearchKeywordUseCase: TrendingSearchKeywordUseCase
  @Published private(set) var searchKeywordFetchingState: SearchKeywordFetchingState = .idle
  enum SearchKeywordFetchingState {
    case idle
    case loading
    case success
  }
  
  @Published private(set) var cakeImages: [CakeImage] = []
  private let searchCakeImagesUseCase: SearchCakeImagesUseCase
  private(set) var lastSearchCakeImageKeyword = ""
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case success
    case failure
    case loadMoreFailure
  }
  
  @Published private(set) var cakeShops: [CakeShop] = []
  private let searchCakeShopUseCase: SearchCakeShopUseCase
  private(set) var lastSearchCakeShopKeyword = ""
  @Published private(set) var cakeShopFetchingState: CakeShopFetchingState = .idle
  enum CakeShopFetchingState {
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
    searchCakeImagesUseCase: SearchCakeImagesUseCase,
    searchCakeShopUseCase: SearchCakeShopUseCase
  ) {
    self.trendingSearchKeywordUseCase = trendingSearchKeywordUseCase
    self.searchCakeImagesUseCase = searchCakeImagesUseCase
    self.searchCakeShopUseCase = searchCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchTrendingSearchKeywords() {
    searchKeywordFetchingState = .loading
    
    trendingSearchKeywordUseCase
      .execute(count: 10)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        self?.searchKeywordFetchingState = .success
        print(completion)
      } receiveValue: { [weak self] keywords in
        self?.trendingSearchKeywords = keywords
      }
      .store(in: &cancellables)
  }
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    
    searchCakeImagesUseCase
      .execute(keyword: searchKeyword.trimmingCharacters(in: .whitespaces),
               latitude: nil,
               longitude: nil,
               pageSize: 10,
               lastCakeId: cakeImages.last?.id)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.imageFetchingState = .failure
        } else {
          self?.imageFetchingState = .success
          self?.lastSearchCakeImageKeyword = self?.searchKeyword ?? ""
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
                                      latitude: nil, 
                                      longitude: nil,
                                      pageSize: 10,
                                      lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .loadMoreFailure
            print(error)
          } else {
            self?.imageFetchingState = .success
          }
        } receiveValue: { [weak self] value in
          self?.cakeImages.append(contentsOf: value)
        }
        .store(in: &cancellables)
    }
  }
  
  public func fetchCakeShops() {
    cakeShopFetchingState = .loading
    
    searchCakeShopUseCase
      .execute(keyword: searchKeyword,
               latitude: nil,
               longitude: nil,
               pageSize: 10,
               lastCakeShopId: nil)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopFetchingState = .failure
          print(error)
        } else {
          self?.cakeShopFetchingState = .success
          self?.lastSearchCakeShopKeyword = self?.searchKeyword ?? ""
        }
      } receiveValue: { [weak self] cakeShops in
        self?.cakeShops = cakeShops
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeShops() {
    cakeShopFetchingState = .loading
    
    if let lastCakeShopId = cakeShops.last?.shopId {
      searchCakeShopUseCase
        .execute(keyword: searchKeyword,
                 latitude: nil,
                 longitude: nil,
                 pageSize: 10,
                 lastCakeShopId: lastCakeShopId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.cakeShopFetchingState = .failure
            print(error)
          } else {
            self?.cakeShopFetchingState = .success
          }
        } receiveValue: { [weak self] cakeShops in
          self?.cakeShops.append(contentsOf: cakeShops)
        }
        .store(in: &cancellables)
    }
  }
  
  // MARK: - Private Methods
}
