//
//  SearchRepository.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchRepository {
  func fetchTrendingSearchKeywords(count: Int) -> AnyPublisher<[String], Error>
  func fetchCakeImages(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
  func fetchCakeShops(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[CakeShop], Error>
  func fetchLocatedCakeShops(latitude: Double, longitude: Double) -> AnyPublisher<[LocatedCakeShop], Error>
}
