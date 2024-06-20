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
import DomainUser

public final class CakeShopQuickInfoViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let imageId: Int
  private(set) var shopId: Int
  
  private let cakeQuickInfoUseCase: CakeShopQuickInfoUseCase
  @Published private(set) var shopInfo: CakeShopQuickInfo?
  @Published private(set) var cakeImageUrl: String
  @Published private(set) var dataFetchingState: DataFetchingState = .idle
  enum DataFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  private let likeCakeImageUseCase: LikeCakeImageUseCase
  @Published private(set) var isLiked = false
  @Published private(set) var likeUpdatingState: LikeUpdatingState = .idle
  enum LikeUpdatingState {
    case idle
    case loading
    case failure
    case sessionExpired
  }
  
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    imageId: Int,
    cakeImageUrl: String, // TODO: 이미지 id를 통해서 cakeImageUrl과 shopId를 가져올 수 있도록 백엔드에 요청
    shopId: Int,
    cakeQuickInfoUseCase: CakeShopQuickInfoUseCase,
    likeCakeImageUseCase: LikeCakeImageUseCase
  ) {
    self.imageId = imageId
    self.cakeImageUrl = cakeImageUrl
    self.shopId = shopId
    
    self.cakeQuickInfoUseCase = cakeQuickInfoUseCase
    self.likeCakeImageUseCase = likeCakeImageUseCase
    
    fetchInitialLikeState()
  }
  
  
  // MARK: - Public Methods
  
  func requestCakeShopQuickInfo() {
    dataFetchingState = .loading
    
    cakeQuickInfoUseCase.execute(shopId: shopId)
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
  
  public func toggleLike() {
    if isLiked {
      unlike()
    } else {
      like()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func like() {
    if likeUpdatingState == .loading { return }
    likeUpdatingState = .loading
    
    likeCakeImageUseCase.likeCakeImage(imageId: imageId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          if error == .sessionExpired {
            self?.likeUpdatingState = .sessionExpired
          } else {
            self?.likeUpdatingState = .failure
          }
        } else {
          self?.likeUpdatingState = .idle
          self?.isLiked = true
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  private func unlike() {
    if likeUpdatingState == .loading { return }
    likeUpdatingState = .loading
    
    likeCakeImageUseCase.unlikeCakeImage(imageId: imageId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          if error == .sessionExpired {
            self?.likeUpdatingState = .sessionExpired
          } else {
            self?.likeUpdatingState = .failure
          }
        } else {
          self?.likeUpdatingState = .idle
          self?.isLiked = false
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  private func fetchInitialLikeState() {
    likeUpdatingState = .loading
    
    likeCakeImageUseCase.fetchCakeImageLikedState(imageId: imageId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.likeUpdatingState = .failure
          print(error)
        } else {
          self?.likeUpdatingState = .idle
        }
      } receiveValue: { [weak self] isLiked in
        self?.isLiked = isLiked
      }
      .store(in: &cancellables)
  }
}
