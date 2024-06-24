//
//  SearchCakeShopUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class SearchCakeShopUseCaseImpl: SearchCakeShopUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[CakeShop], any Error> {
    repository.fetchCakeShops(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeShopId: lastCakeShopId)
  }
}
