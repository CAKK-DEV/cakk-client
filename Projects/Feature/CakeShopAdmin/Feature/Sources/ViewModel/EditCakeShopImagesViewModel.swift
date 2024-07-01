//
//  EditCakeShopImagesViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class EditCakeShopImagesViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private(set) var shopId: Int
  
  private let cakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase
  @Published private(set) var cakeImages: [CakeImage] = []
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case loadingMore
    case failure
    case failureLoadMore
    case success
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase
  ) {
    self.shopId = shopId
    self.cakeImagesByShopIdUseCase = cakeImagesByShopIdUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    cakeImages.removeAll()
    
    cakeImagesByShopIdUseCase.execute(shopId: shopId, count: 10, lastCakeId: nil)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.imageFetchingState = .failure
          print(error)
        } else {
          self?.imageFetchingState = .success
        }
      } receiveValue: { [weak self] value in
        self?.cakeImages = value
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loadingMore
    
    if let lastCakeId = cakeImages.last?.id {
      cakeImagesByShopIdUseCase.execute(shopId: shopId, count: 10, lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .failureLoadMore
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
}
