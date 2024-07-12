//
//  CakeShopDetailViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainCakeShop
import DomainSearch

public final class CakeShopDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  var shopId: Int
  
  private let cakeShopDetailUseCase: CakeShopDetailUseCase
  @Published private(set) var cakeShopDetail: CakeShopDetail?
  @Published private(set) var cakeShopDetailFetchingState: CakeShopDetailFetchingState = .idle
  enum CakeShopDetailFetchingState: Equatable {
    case idle
    case loading
    case failure(error: CakeShopDetailError)
    case success
  }

  private let cakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase
  @Published private(set) var cakeImages: [CakeImage] = []
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case loadMore
    case failure
    case failureLoadMore
    case success
  }
  
  private let cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  @Published private(set) var additionalInfo: CakeShopAdditionalInfo?
  @Published private(set) var additionalInfoFetchingState: AdditionalInfoFetchingState = .idle
  enum AdditionalInfoFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopDetailUseCase: CakeShopDetailUseCase,
    cakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase,
    cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  ) {
    self.shopId = shopId
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
    self.cakeImagesByShopIdUseCase = cakeImagesByShopIdUseCase
    self.cakeShopAdditionalInfoUseCase = cakeShopAdditionalInfoUseCase
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
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    cakeImages.removeAll()
    
    cakeImagesByShopIdUseCase.execute(shopId: shopId, count: 10, lastCakeId: nil)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.imageFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.imageFetchingState = .success
        }
      } receiveValue: { [weak self] value in
        self?.cakeImages = value
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loadMore
    
    if let lastCakeId = cakeImages.last?.id {
      cakeImagesByShopIdUseCase.execute(shopId: shopId, count: 10, lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .failureLoadMore
            print(error.localizedDescription)
          } else {
            self?.imageFetchingState = .idle
          }
        } receiveValue: { [weak self] value in
          self?.cakeImages.append(contentsOf: value)
        }
        .store(in: &cancellables)
    }
  }
  
  public func fetchAdditionalInfo() {
    additionalInfoFetchingState = .loading
    
    cakeShopAdditionalInfoUseCase.execute(shopId: shopId)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.additionalInfoFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.additionalInfoFetchingState = .success
        }
      } receiveValue: { [weak self] additionalInfo in
        self?.additionalInfo = additionalInfo
      }
      .store(in: &cancellables)
  }
}
