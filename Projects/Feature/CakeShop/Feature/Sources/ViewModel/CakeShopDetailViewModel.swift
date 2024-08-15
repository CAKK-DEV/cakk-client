//
//  CakeShopDetailViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonUtil

import CommonDomain
import DomainCakeShop
import DomainUser
import DomainSearch

import FirebaseFirestore
import Logger

public final class CakeShopDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  
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
  
  private let likeCakeShopUseCase: LikeCakeShopUseCase
  @Published private(set) var isLiked = false
  @Published private(set) var likeUpdatingState: LikeUpdatingState = .idle
  enum LikeUpdatingState {
    case idle
    case loading
    case failure
    case sessionExpired
  }
  
  private let cakeShopOwnedStateUseCase: CakeShopOwnedStateUseCase
  @Published private(set) var isOwned = false
  
  private let myShopIdUseCase: MyShopIdUseCase
  @Published private(set) var isMyShop = false
  
  private let firestoreDB = Firestore.firestore()
  private var cakeShopPromptListener: ListenerRegistration?
  private let collectionName = "ShopPrompt"
  @Published private(set) var cakeShopPromptCount = 0
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopDetailUseCase: CakeShopDetailUseCase,
    cakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase,
    cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase,
    likeCakeShopUseCase: LikeCakeShopUseCase,
    cakeShopOwnedStateUseCase: CakeShopOwnedStateUseCase,
    myShopIdUseCase: MyShopIdUseCase
  ) {
    self.shopId = shopId
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
    self.cakeImagesByShopIdUseCase = cakeImagesByShopIdUseCase
    self.cakeShopAdditionalInfoUseCase = cakeShopAdditionalInfoUseCase
    self.likeCakeShopUseCase = likeCakeShopUseCase
    self.cakeShopOwnedStateUseCase = cakeShopOwnedStateUseCase
    self.myShopIdUseCase = myShopIdUseCase
    
    fetchInitialLikeState()
    fetchCakeShopOwnedState()
    fetchIsMyCakeShop()
  }
  
  deinit {
    cakeShopPromptListener?.remove()
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
    imageFetchingState = .loading
    
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
  
  public func toggleLike() {
    if isLiked {
      unlike()
    } else {
      like()
    }
  }
  
  public func makeNaverMapUrl() -> URL? {
    guard let placeName = cakeShopDetail?.shopName,
          let appName = Bundle.main.bundleIdentifier else {
      return nil
    }
    
    let urlStr = "nmap://search?query=\(placeName)&appname=com.example.myapp"
    return URL(string: urlStr)
  }
  
  public func fetchCakeShopPromptCount() {
    let shopPromptRef = firestoreDB.collection(collectionName).document(shopId.description)
    self.cakeShopPromptListener = shopPromptRef.addSnapshotListener { [weak self] documentSnapshot, error in
      if let error = error {
        Loggers.featureCakeShop.log("Firestore 에러 발생: \(error.localizedDescription)", category: .network)
        return
      }
      
      guard let document = documentSnapshot else {
        Loggers.featureCakeShop.log("CakeShopPrompt Firestore 스냅샷 읽기에 실패하였습니다.", category: .network)
        return
      }
      
      if let data = document.data(), let promptCount = data["prompt_count"] as? Int {
        DispatchQueue.main.async {
          self?.cakeShopPromptCount = promptCount
          print("Current prompt count: \(promptCount)")
        }
      } else {
        print("데이터 로드 실패")
      }
    }
  }
  
  public func increaseCakeShopPromptCount() {
    let shopPromptRef = firestoreDB.collection(collectionName).document(shopId.description)
    shopPromptRef.setData(["prompt_count" : cakeShopPromptCount + 1]) { [weak self] error in
      if let error {
        Loggers.featureCakeShop.log("Firestore 업데이트 실패 \(error.localizedDescription)", category: .network)
        return
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func like() {
    if likeUpdatingState == .loading { return }
    likeUpdatingState = .loading
    
    likeCakeShopUseCase.likeCakeShop(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          if error == .sessionExpired {
            self?.likeUpdatingState = .sessionExpired
          } else {
            self?.likeUpdatingState = .failure
          }
          
        case .finished:
          self?.likeUpdatingState = .idle
          self?.isLiked = true
          
          /// 케이크샵 좋아요가 변경되었다면 좋아요한 케이크샵 데이터를 리프레시하기 위한 플래그 입니다
          GlobalSettings.didChangeCakeShopLikeState = true
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  private func unlike() {
    if likeUpdatingState == .loading { return }
    likeUpdatingState = .loading
    
    likeCakeShopUseCase.unlikeCakeShop(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          if error == .sessionExpired {
            self?.likeUpdatingState = .sessionExpired
          } else {
            self?.likeUpdatingState = .failure
          }
          
        case .finished:
          self?.likeUpdatingState = .idle
          self?.isLiked = false
          
          /// 케이크샵 좋아요가 변경되었다면 좋아요한 케이크샵 데이터를 리프레시하기 위한 플래그 입니다
          GlobalSettings.didChangeCakeShopLikeState = true
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  private func fetchInitialLikeState() {
    likeUpdatingState = .loading
    
    likeCakeShopUseCase.fetchCakeShopLikedState(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.likeUpdatingState = .failure
          print(error.localizedDescription)
        } else {
          self?.likeUpdatingState = .idle
        }
      } receiveValue: { [weak self] isLiked in
        self?.isLiked = isLiked
      }
      .store(in: &cancellables)
  }
  
  private func fetchCakeShopOwnedState() {
    cakeShopOwnedStateUseCase.execute(shopId: shopId)
      .sink { completion in
        if case .failure(let error) = completion {
          print(error.localizedDescription)
        }
      } receiveValue: { [weak self] isOwned in
        self?.isOwned = isOwned
      }
      .store(in: &cancellables)
  }
  
  private func fetchIsMyCakeShop() {
    myShopIdUseCase.execute()
      .sink { completion in
        if case .failure(let error) = completion {
          print(error.localizedDescription)
        }
      } receiveValue: { [weak self] shopId in
        self?.isMyShop = shopId == self?.shopId
      }
      .store(in: &cancellables)
  }
}
