//
//  CakeShopDetailUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class CakeShopDetailUseCaseImpl: CakeShopDetailUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopDetailRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopDetailRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int) -> AnyPublisher<DomainCakeShop.CakeShopDetail, DomainCakeShop.CakeShopDetailError> {
    repository.fetch(shopId: shopId)
  }
}
