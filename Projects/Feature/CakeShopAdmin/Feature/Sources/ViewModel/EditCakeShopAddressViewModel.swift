//
//  EditCakeShopAddressViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import LocationService

public final class EditCakeShopAddressViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  
  private var originalCakeShopLocation: CakeShopLocation!
  @Published var cakeShopLocation: CakeShopLocation!
  
  private let cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  @Published private(set) var shopAddressFetchingState: ShopAddressFetchingState = .idle
  enum ShopAddressFetchingState: Equatable {
    case idle
    case loading
    case failure
    case success
  }
  
  private let editShopAddressUseCase: EditShopAddressUseCase
  @Published private(set) var updatingState: UpdatingState = .idle
  enum UpdatingState {
    case idle
    case loading
    case success
    case failure
    case emptyAddress
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase,
    editShopAddressUseCase: EditShopAddressUseCase
  ) {
    self.shopId = shopId
    self.cakeShopAdditionalInfoUseCase = cakeShopAdditionalInfoUseCase
    self.editShopAddressUseCase = editShopAddressUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchShopAddress() {
    shopAddressFetchingState = .loading
    
    cakeShopAdditionalInfoUseCase.execute(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.shopAddressFetchingState = .failure
        } else {
          self?.shopAddressFetchingState = .success
        }
      } receiveValue: { [weak self] additionalInfo in
        self?.originalCakeShopLocation = additionalInfo.location
        self?.cakeShopLocation = additionalInfo.location
      }
      .store(in: &cancellables)
  }
  
  public func updateShopAddress() {
    if cakeShopLocation.address.isEmpty {
      updatingState = .emptyAddress
      return
    }
    
    updatingState = .loading
    
    editShopAddressUseCase.execute(cakeShopId: shopId,
                                   address: cakeShopLocation.address,
                                   latitude: cakeShopLocation.latitude,
                                   longitude: cakeShopLocation.longitude)
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
  
  public func updateCoordinates(latitude: Double, longitude: Double) {
    self.cakeShopLocation.latitude = latitude
    self.cakeShopLocation.longitude = longitude
  }
  
  public func hasChanges() -> Bool {
    if cakeShopLocation != originalCakeShopLocation {
      return true
    }
    return false
  }
}
