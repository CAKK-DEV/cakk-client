//
//  CakeShopDetailViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class CakeShopDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  private let cakeShopDetailUseCase: CakeShopDetailUseCase
  
  @Published private(set) var cakeShopDetail: CakeShopDetail?
  
  @Published private(set) var cakeShopDetailFetchingState: CakeShopDetailFetchingState = .idle
  enum CakeShopDetailFetchingState {
    case idle
    case loading
    case failure(error: CakeShopDetailError)
    case success
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopDetailUseCase: CakeShopDetailUseCase
  ) {
    self.shopId = shopId
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeShopDetail() {
    cakeShopDetailFetchingState = .loading
    
    cakeShopDetailUseCase.execute(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopDetailFetchingState = .failure(error: error)
        } else {
          self?.cakeShopDetailFetchingState = .success
        }
      } receiveValue: { [weak self] cakeShopDetail in
        self?.cakeShopDetail = cakeShopDetail
      }
      .store(in: &cancellables)
  }
  
  
  // MARK: - Private Methods
}
