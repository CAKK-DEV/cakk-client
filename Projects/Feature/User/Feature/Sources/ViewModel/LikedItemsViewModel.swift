//
//  LikedItemsViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import CommonUtil

import DomainUser

public final class LikedItemsViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published private(set) var cakeImages: [LikedCakeImage] = []
  private let likeCakeImageUseCase: LikeCakeImageUseCase
  private(set) var lastSearchCakeImageKeyword = ""
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case success
    case failure
    case loadMoreFailure
  }
  
  @Published private(set) var cakeShops: [LikedCakeShop] = []
  private let likeCakeShopUseCase: LikeCakeShopUseCase
  private(set) var lastSearchCakeShopKeyword = ""
  @Published private(set) var cakeShopFetchingState: CakeShopFetchingState = .idle
  enum CakeShopFetchingState {
    case idle
    case loading
    case success
    case failure
    case loadMoreFailure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    likeCakeImageUseCase: LikeCakeImageUseCase,
    likeCakeShopUseCase: LikeCakeShopUseCase
  ) {
    self.likeCakeImageUseCase = likeCakeImageUseCase
    self.likeCakeShopUseCase = likeCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    
    likeCakeImageUseCase
      .fetchLikedCakeImages(lastImageId: nil, pageSize: 10)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.imageFetchingState = .failure
        } else {
          self?.imageFetchingState = .success
          
          /// 변경된 데이터를 새로 불러왔다면 변경됨 상태를 false 초기화 합니다.
          GlobalSettings.didChangeCakeImageLikeState = false
        }
      } receiveValue: { [weak self] cakeImages in
        self?.cakeImages = cakeImages
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loading
    
    if let lastCakeHeartId = cakeImages.last?.cakeHeartId {
      likeCakeImageUseCase
        .fetchLikedCakeImages(lastImageId: lastCakeHeartId, pageSize: 10)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          switch completion {
          case .failure(let error):
            self?.imageFetchingState = .loadMoreFailure
            print(error.localizedDescription)
            
          case .finished:
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
    
    likeCakeShopUseCase
      .fetchLikedCakeShops(lastShopId: nil, pageSize: 10)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.cakeShopFetchingState = .failure
          print(error.localizedDescription)
          
        case .finished:
          self?.cakeShopFetchingState = .success
          
          /// 변경된 데이터를 새로 불러왔다면 변경됨 상태를 false 초기화 합니다.
          GlobalSettings.didChangeCakeShopLikeState = false
        }
      } receiveValue: { [weak self] cakeShops in
        self?.cakeShops = cakeShops
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeShops() {
    cakeShopFetchingState = .loading
    
    if let lastCakeShopHeartId = cakeShops.last?.shopHeartId {
      likeCakeShopUseCase
        .fetchLikedCakeShops(lastShopId: lastCakeShopHeartId, pageSize: 10)
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
}
