//
//  EditShopAddressUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import UserSession

public final class EditShopAddressUseCaseImpl: EditShopAddressUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeShopId: Int, address: String, latitude: Double, longitude: Double) -> AnyPublisher<Void, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.editShopAddress(cakeShopId: cakeShopId, address: address, latitude: latitude, longitude: longitude, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      Fail(error: CakeShopError.failure)
        .eraseToAnyPublisher()
    }
  }
}
