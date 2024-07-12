//
//  TrendingCakeShopViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainSearch

public final class TrendingCakeShopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let useCase: TrendingCakeShopsUseCase
  @Published private(set) var trendingCakeShops: [CakeShop] = []
  @Published private(set) var trendingCakeShopFetchingState: TrendingCakeShopFetchingState = .idle
  enum TrendingCakeShopFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(useCase: TrendingCakeShopsUseCase) {
    self.useCase = useCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchTrendingCakeShop() {
    trendingCakeShopFetchingState = .loading
    
    useCase.execute()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.trendingCakeShopFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.trendingCakeShopFetchingState = .success
        }
      } receiveValue: { [weak self] trendingCakeShops in
        self?.trendingCakeShops = trendingCakeShops
      }
      .store(in: &cancellables)
  }
}
