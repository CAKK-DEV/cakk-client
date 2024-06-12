//
//  CakeImagesByCategoryRepositoryImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import Moya
import CombineMoya

import DomainCakeShop

public final class CakeImagesByCategoryRepositoryImpl: CakeImagesByCategoryRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<CakeShopAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<CakeShopAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetch(category: DomainCakeShop.CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[DomainCakeShop.CakeImage], any Error> {
    provider.requestPublisher(.fetchCakeImagesByCategory(category.toDTO(), count: count, lastCakeId: lastCakeId))
      .map { $0.data }
      .decode(type: CakeImagesResponseDTO.self, decoder: JSONDecoder())
      .tryMap { response in
        response.toDomain()
      }
      .eraseToAnyPublisher()
  }
}
