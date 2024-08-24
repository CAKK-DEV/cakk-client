//
//  BusinessOwnerProfileViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import DomainUser

public final class BusinessOwnerProfileViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private(set) var shopId: Int?
  
  private let myShopIdUseCase: MyShopIdUseCase
  
  @Published private(set) var businessOwnerInfoFetchingState: BusinessOwnerInfoFetchingState = .idle
  enum BusinessOwnerInfoFetchingState: Equatable {
    case idle
    case loading
    case failure
    case success
  }
  
  private let cakeShopDetailUseCase: CakeShopDetailUseCase
  @Published private(set) var cakeShopDetail: CakeShopDetail?
  
  private var cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  @Published private(set) var cakeShopAdditionalInfo: CakeShopAdditionalInfo?
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    myShopIdUseCase: MyShopIdUseCase,
    cakeShopDetailUseCase: CakeShopDetailUseCase,
    cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  ) {
    self.myShopIdUseCase = myShopIdUseCase
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
    self.cakeShopAdditionalInfoUseCase = cakeShopAdditionalInfoUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchMyCakeShopId() {
//    myShopIdUseCase.execute()
//      .sink { [weak self] completion in
//        if case .failure(let error) = completion {
//          self?.businessOwnerInfoFetchingState = .failure
//          print(error.localizedDescription)
//        }
//      } receiveValue: { [weak self] shopId in
//        self?.shopId = shopId
//        self?.fetchCakeShopDetailAndAdditionalInfo()
//      }
//      .store(in: &cancellables)
    
    self.shopId = 278
  }
  
  private func fetchCakeShopDetailAndAdditionalInfo() {
    guard let shopId = shopId else {
      businessOwnerInfoFetchingState = .failure
      return
    }
    
    businessOwnerInfoFetchingState = .loading
    
    let detailPublisher = cakeShopDetailUseCase.execute(shopId: shopId)
      .mapError { $0 as Error }
    let additionalInfoPublisher = cakeShopAdditionalInfoUseCase.execute(shopId: shopId)
      .mapError { $0 as Error }
    
    Publishers.Zip(detailPublisher, additionalInfoPublisher)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.businessOwnerInfoFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.businessOwnerInfoFetchingState = .success
        }
      } receiveValue: { [weak self] (detail, additionalInfo) in
        self?.cakeShopDetail = detail
        self?.cakeShopAdditionalInfo = additionalInfo
      }
      .store(in: &cancellables)
  }
}
