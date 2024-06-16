//
//  SearchRepositoryImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import Moya
import CombineMoya

import DomainSearch

public final class SearchRepositoryImpl: SearchRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<SearchAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<SearchAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchTrendingSearchKeywords(count: Int) -> AnyPublisher<[String], any Error> {
    provider.requestPublisher(.fetchTrendingSearchKeyword(count: count))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(TrendingSearchKeywordResponseDTO.self, from: response.data)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(TrendingSearchKeywordResponseDTO.self, from: response.data)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImages(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    provider.requestPublisher(.fetchCakeImages(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeId: lastCakeId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(CakeImagesResponseDTO.self, from: response.data)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(CakeImagesResponseDTO.self, from: response.data)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeShops(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[DomainSearch.CakeShop], any Error> {
    provider.requestPublisher(.fetchCakeShops(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeShopId: lastCakeShopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(CakeShopsResponseDTO.self, from: response.data)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(CakeShopsResponseDTO.self, from: response.data)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .eraseToAnyPublisher()
  }
}
