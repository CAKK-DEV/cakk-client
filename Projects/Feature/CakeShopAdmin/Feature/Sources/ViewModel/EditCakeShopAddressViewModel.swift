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
  private let editShopAddressUseCase: EditShopAddressUseCase
  
  private let originalCakeShopLocation: CakeShopLocation
  @Published var cakeShopLocation: CakeShopLocation
  
  @Published private(set) var updatingState: UpdatingState = .idle
  enum UpdatingState {
    case idle
    case loading
    case success
    case failure
    case emptyAddress
  }
  
  private var cancellabels = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopLocation: CakeShopLocation,
    editShopAddressUseCase: EditShopAddressUseCase
  ) {
    self.shopId = shopId
    self.originalCakeShopLocation = cakeShopLocation
    self.cakeShopLocation = cakeShopLocation
    self.editShopAddressUseCase = editShopAddressUseCase
  }
  
  
  // MARK: - Public Methods
  
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
      .store(in: &cancellabels)
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
