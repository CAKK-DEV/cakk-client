//
//  SearchMyShopViewModel.swift
//  FeatureBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainSearch

public final class SearchMyShopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var searchKeyword: String = ""
  
  private let searchCakeShopUseCase: SearchCakeShopUseCase
  @Published private(set) var cakeShops: [CakeShop] = []
  @Published private(set) var cakeShopFetchingState: CakeShopFetchingState = .idle
  enum CakeShopFetchingState {
    case idle
    case loading
    case loadMore
    case success
    case failure
  }
  
  private var cancellabels = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(searchCakeShopUseCase: SearchCakeShopUseCase) {
    self.searchCakeShopUseCase = searchCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeShop() {
    if searchKeyword.isEmpty { return }
    
    cakeShopFetchingState = .loading
    
    searchCakeShopUseCase
      .execute(keyword: searchKeyword, latitude: nil, longitude: nil, pageSize: 10, lastCakeShopId: nil)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeShopFetchingState = .success
        }
      } receiveValue: { [weak self] searchResult in
        self?.cakeShops = searchResult
      }
      .store(in: &cancellabels)
  }
  
  public func fetchMoreCakeShop() {
    if searchKeyword.isEmpty { return }
    
    if let lastCakeShopId = cakeShops.last?.shopId {
      cakeShopFetchingState = .loadMore
      
      searchCakeShopUseCase
        .execute(keyword: searchKeyword, latitude: nil, longitude: nil, pageSize: 10, lastCakeShopId: lastCakeShopId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.cakeShopFetchingState = .failure
            print(error.localizedDescription)
          } else {
            self?.cakeShopFetchingState = .success
          }
        } receiveValue: { [weak self] searchResult in
          self?.cakeShops.append(contentsOf: searchResult)
        }
        .store(in: &cancellabels)
    }
  }
}
