//
//  EditShopBasicInfoUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import UserSession

public final class EditShopBasicInfoUseCaseImpl: EditShopBasicInfoUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeShopId: Int, newCakeShopBasicInfo: NewCakeShopBasicInfo) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.editShopBasicInfo(shopId: cakeShopId, newCakeShopBasicInfo: newCakeShopBasicInfo, accessToken: accessToken)
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
