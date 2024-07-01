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
  
  private(set) var originalCakeShopDetail: CakeShopDetail
  
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
    shopDetail: CakeShopDetail,
    editShopBasicInfoUseCase: EditShopBasicInfoUseCase
  ) {
    self.originalCakeShopDetail = shopDetail
    self.editShopBasicInfoUseCase = editShopBasicInfoUseCase
    
    self.editedBasicInfo = .init(profileImage: shopDetail.thumbnailImageUrl != nil
                                 ? .original(imageUrl: shopDetail.thumbnailImageUrl!)
                                 : .none,
                                 shopName: shopDetail.shopName,
                                 shopBio: shopDetail.shopBio,
                                 shopDescription: shopDetail.shopDescription)
  }
  
  
  // MARK: - Public Methods
  
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
