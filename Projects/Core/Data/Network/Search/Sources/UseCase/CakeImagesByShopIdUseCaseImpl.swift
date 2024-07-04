//
//  CakeImagesByShopIdUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainSearch

public final class CakeImagesByShopIdUseCaseImpl: CakeImagesByShopIdUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    repository.fetchCakeImages(shopId: shopId, count: count, lastCakeId: lastCakeId)
  }
}
