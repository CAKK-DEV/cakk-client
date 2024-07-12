//
//  SearchRepository.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain

public protocol SearchRepository {
  
  // MARK: - Trendings
  
  func fetchTrendingSearchKeywords(count: Int) -> AnyPublisher<[String], Error>
  func fetchTrendingCakeShops(count: Int) -> AnyPublisher<[CakeShop], Error>
  
  // MARK: - CakeImages
  
  func fetchCakeImages(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
  func fetchCakeImages(category: CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
  func fetchCakeImages(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
  
  
  // MARK: - CakeShops
  
  func fetchCakeShops(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[CakeShop], Error>
  func fetchLocatedCakeShops(latitude: Double, longitude: Double) -> AnyPublisher<[LocatedCakeShop], Error>
}
