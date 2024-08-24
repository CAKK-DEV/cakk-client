//
//  EditCakeShopBasicInfoViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

import Combine

public final class EditCakeShopBasicInfoViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  
  private let cakeShopDetailUseCase: CakeShopDetailUseCase
  private(set) var originalCakeShopDetail: CakeShopDetail!
  @Published private(set) var cakeShopDetailFetchingState: CakeShopDetailFetchingState = .idle
  enum CakeShopDetailFetchingState: Equatable {
    case idle
    case loading
    case failure(error: CakeShopDetailError)
    case success
  }
  
  private let editShopBasicInfoUseCase: EditShopBasicInfoUseCase
  @Published var editedBasicInfo: NewCakeShopBasicInfo!
  @Published private(set) var basicInfoUpdatingState: BasicInfoUpdatingState = .idle
  enum BasicInfoUpdatingState: Equatable {
    case idle
    case loading
    case success
    case failure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopDetailUseCase: CakeShopDetailUseCase,
    editShopBasicInfoUseCase: EditShopBasicInfoUseCase
  ) {
    self.shopId = shopId
    self.cakeShopDetailUseCase = cakeShopDetailUseCase
    self.editShopBasicInfoUseCase = editShopBasicInfoUseCase
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
        self?.originalCakeShopDetail = cakeShopDetail
        self?.editedBasicInfo = .init(profileImage: cakeShopDetail.thumbnailImageUrl != nil
                                     ? .original(imageUrl: cakeShopDetail.thumbnailImageUrl!)
                                     : .none,
                                     shopName: cakeShopDetail.shopName,
                                     shopBio: cakeShopDetail.shopBio,
                                     shopDescription: cakeShopDetail.shopDescription)
      }
      .store(in: &cancellables)
  }
  
  public func basicInfoHasChanges() -> Bool {
    if editedBasicInfo.profileImage != .none
        && editedBasicInfo.profileImage != .original(imageUrl: originalCakeShopDetail.thumbnailImageUrl ?? "") {
      return true
    } else if originalCakeShopDetail.shopName != editedBasicInfo.shopName ||
                originalCakeShopDetail.shopBio != editedBasicInfo.shopBio ||
                originalCakeShopDetail.shopDescription != editedBasicInfo.shopDescription {
      return true
    } else {
      return false
    }
  }
  
  public func updateShopBasicInfo() {
    basicInfoUpdatingState = .loading
    
    editShopBasicInfoUseCase.execute(cakeShopId: originalCakeShopDetail.shopId,
                                     newCakeShopBasicInfo: editedBasicInfo)
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.basicInfoUpdatingState = .failure
        print(error.localizedDescription)
      } else {
        self?.basicInfoUpdatingState = .success
      }
    } receiveValue: { _ in }
      .store(in: &cancellables)
  }
}
