//
//  SearchLocatedCakeShopUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public final class SearchLocatedCakeShopUseCaseImpl: SearchLocatedCakeShopUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(distance: Int, longitude: Double, latitude: Double) -> AnyPublisher<[DomainSearch.LocatedCakeShop], any Error> {
    repository.fetchLocatedCakeShops(distance: distance, latitude: latitude, longitude: longitude)
  }
}
