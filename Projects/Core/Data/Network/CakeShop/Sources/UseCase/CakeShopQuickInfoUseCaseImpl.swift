//
//  CakeShopQuickInfoUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public struct CakeShopQuickInfoUseCaseImpl: CakeShopQuickInfoUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopQuickInfoRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopQuickInfoRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int) -> AnyPublisher<DomainCakeShop.CakeShopQuickInfo, any Error> {
    repository.fetch(shopId: shopId)
      .eraseToAnyPublisher()
  }
}
