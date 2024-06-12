//
//  CakeShopAdditionalInfoUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class CakeShopAdditionalInfoUseCaseImpl: CakeShopAdditionalInfoUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopDetailRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopDetailRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, any Error> {
    repository.fetchAdditionalInfo(shopId: shopId)
  }
}
