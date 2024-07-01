//
//  CakeShopListViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class CakeShopListViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var searchKeyword = ""
  
  private let searchCakeShopUseCase: SearchCakeShopUseCase
  @Published private(set) var cakeShops: [CakeShop] = []
  @Published private(set) var cakeShopFetchingState: SearchCakeShopFetchingState = .idle
  enum SearchCakeShopFetchingState {
    case idle
    case loading
    case loadMore
    case success
    case failure
    case fetchMoreFailure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(searchCakeShopUseCase: SearchCakeShopUseCase) {
    self.searchCakeShopUseCase = searchCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeShops() {
    cakeShopFetchingState = .loading
    
    searchCakeShopUseCase.execute(keyword: searchKeyword.isEmpty ? nil : searchKeyword, latitude: nil, longitude: nil, pageSize: 20, lastCakeShopId: nil)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeShopFetchingState = .success
        }
      } receiveValue: { [weak self] cakeShops in
        self?.cakeShops = cakeShops
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeShop() {
    guard let lastCakeShopId = cakeShops.last?.shopId else { return }
    
    cakeShopFetchingState = .loadMore
    
    searchCakeShopUseCase.execute(keyword: nil, latitude: nil, longitude: nil, pageSize: 20, lastCakeShopId: lastCakeShopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeShopFetchingState = .success
        }
      } receiveValue: { [weak self] cakeShops in
        self?.cakeShops.append(contentsOf: cakeShops)
      }
      .store(in: &cancellables)
  }
}
