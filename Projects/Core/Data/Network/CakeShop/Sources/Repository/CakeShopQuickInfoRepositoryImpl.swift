//
//  CakeShopQuickInfoRepositoryImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

import Moya
import CombineMoya

final public class CakeShopQuickInfoRepositoryImpl: CakeShopQuickInfoRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<CakeShopAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<CakeShopAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetch(shopId: Int, cakeImageId: Int?) -> AnyPublisher<DomainCakeShop.CakeShopQuickInfo, any Error> {
    provider.requestPublisher(.fetchCakeShopQuickInfo(shopId: shopId, cakeImageId: cakeImageId))
      .map { $0.data }
      .decode(type: CakeShopQuickInfoDTO.self, decoder: JSONDecoder())
      .tryMap { decodedResponse in
        decodedResponse.toDomain()
      }
      .eraseToAnyPublisher()
  }
}
