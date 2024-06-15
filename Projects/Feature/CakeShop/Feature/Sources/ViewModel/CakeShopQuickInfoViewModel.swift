//
//  CakeShopQuickInfoViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class CakeShopQuickInfoViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private(set) var shopId: Int
  private let useCase: CakeShopQuickInfoUseCase
  
  @Published private(set) var shopInfo: CakeShopQuickInfo?
  @Published private(set) var cakeImageUrl: String
  @Published private(set) var dataFetchingState: DataFetchingState = .idle
  enum DataFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeImageUrl: String,
    useCase: CakeShopQuickInfoUseCase
  ) {
    self.shopId = shopId
    self.cakeImageUrl = cakeImageUrl
    self.useCase = useCase
  }
  
  
  // MARK: - Public Methods
  
  func requestCakeShopQuickInfo() {
    dataFetchingState = .loading
    
    useCase.execute(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          self?.dataFetchingState = .success
        case .failure(let error):
          print(error.localizedDescription)
          self?.dataFetchingState = .failure
        }
      } receiveValue: { [weak self] cakeShopQuickInfo in
        self?.shopInfo = cakeShopQuickInfo
      }
      .store(in: &cancellables)
  }
}
