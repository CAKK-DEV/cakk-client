//
//  TrendingCakeShopUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainSearch

public final class TrendingCakeShopUseCaseImpl: TrendingCakeShopsUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<[CakeShop], any Error> {
    // TODO: 추후 개발 될 인기 케이크샵 API로 변경
    repository.fetchCakeShops(keyword: nil, latitude: nil, longitude: nil, pageSize: 10, lastCakeShopId: nil)
  }
}
