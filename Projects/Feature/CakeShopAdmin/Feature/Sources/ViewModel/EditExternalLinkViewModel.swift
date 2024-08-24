//
//  EditExternalLinkViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainCakeShop

public final class EditExternalLinkViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  
  private let cakeShopDetailUseCase: CakeShopDetailUseCase
  @Published private(set) var externalLinkFetchingState: ExternalLinkFetchingState = .idle
  enum ExternalLinkFetchingState: Equatable {
    case idle
    case loading
    case failure(error: CakeShopDetailError)
    case success
  }
  
  private let editExternalLinkUseCase: EditExternalLinkUseCase
  private var externalShopLinks: [ExternalShopLink] = []
  
  @Published var instaUrl: String = ""
  @Published var kakaoUrl: String = ""
  @Published var webUrl: String = ""
  
  @Published private(set) var updatingState: UpdatingState = .idle
  enum UpdatingState {
    case idle
    case loading
    case success
    case failure
    case invalidUrl
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopDetailUseCase: CakeShopDetailUseCase,
    editExternalLinkUseCase: EditExternalLinkUseCase
  ) {
    self.shopId = shopId
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
    self.editExternalLinkUseCase = editExternalLinkUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchExternalLinks() {
    externalLinkFetchingState = .loading
    
    cakeShopDetailUseCase.execute(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.externalLinkFetchingState = .failure(error: error)
        } else {
          self?.externalLinkFetchingState = .success
        }
      } receiveValue: { [weak self] cakeShopDetail in
        self?.externalShopLinks = cakeShopDetail.externalShopLinks
        self?.externalShopLinks.forEach { link in
          switch link.linkType {
          case .web:
            self?.webUrl = link.linkPath
          case .instagram:
            self?.instaUrl = link.linkPath
          case .kakaotalk:
            self?.kakaoUrl = link.linkPath
          }
        }
      }
      .store(in: &cancellables)
  }
  
  public func updateExternLinks() {
    updatingState = .loading
    
    /// instagram url 유효성을 검사합니다
    if !instaUrl.isEmpty && !isValidURL(instaUrl) {
      updatingState = .invalidUrl
      return
    }
    
    /// kakao url 유효성을 검사합니다
    if !kakaoUrl.isEmpty && !isValidURL(kakaoUrl) {
      updatingState = .invalidUrl
      return
    }
    
    /// web url 유효성을 검사합니다
    if !webUrl.isEmpty && !isValidURL(webUrl) {
      updatingState = .invalidUrl
      return
    }

    editExternalLinkUseCase.execute(
      cakeShopId: shopId,
      instaUrl: instaUrl,
      kakaoUrl: kakaoUrl,
      webUrl: webUrl
    )
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.updatingState = .failure
        print(error.localizedDescription)
      } else {
        self?.updatingState = .success
      }
    } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func hasChanges() -> Bool {
    for shopLink in externalShopLinks {
      switch shopLink.linkType {
      case .web:
        if webUrl != shopLink.linkPath { return true }
      case .instagram:
        if instaUrl != shopLink.linkPath { return true }
      case .kakaotalk:
        if kakaoUrl != shopLink.linkPath { return true }
      }
    }
    
    return false
  }
  
  
  // MARK: - Private Methods

  /// URL이 유효한지 확인합니다
  private func isValidURL(_ urlString: String?) -> Bool {
    if let urlString = urlString {
      if let url = NSURL(string: urlString) {
        return UIApplication.shared.canOpenURL(url as URL)
      }
    }
    return false
  }
}
