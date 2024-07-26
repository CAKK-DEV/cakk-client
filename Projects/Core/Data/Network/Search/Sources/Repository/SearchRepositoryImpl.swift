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

import CommonDomain
import DomainSearch

import Logger

public final class SearchRepositoryImpl: SearchRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<SearchAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<SearchAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchTrendingSearchKeywords(count: Int) -> AnyPublisher<[String], any Error> {
    Loggers.networkSearch.info("인기 검색어를 불러옵니다.", category: .network)
    
    return provider.requestPublisher(.fetchTrendingSearchKeyword(count: count))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(TrendingSearchKeywordResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("인기 검색어 불러오기에 성공하였습니다.\n총 인기 검색어 갯수: \(decodedData.data.totalCount)", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(TrendingSearchKeywordResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("인기 검색어를 불러오는데 실패하였습니다.", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchTrendingCakeShops(count: Int) -> AnyPublisher<[CakeShop], any Error> {
    Loggers.networkSearch.info("인기 케이크샵을 불러옵니다.", category: .network)
    
    return provider.requestPublisher(.fetchTrendingCakeShops(count: count))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(TrendingCakeShopsResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("인기 케이크샵 불러오기에 성공하였습니다.\n총 인기 케이크샵 갯수: \(decodedData.data.cakeShops.count)", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(TrendingCakeShopsResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("인기 케이크샵을 불러오는데 실패하였습니다.", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImages(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    if lastCakeId != nil {
      Loggers.networkSearch.info("케이크 이미지를 더 불러옵니다.\n검색 키워드: \(keyword ?? "키워드 없음")\nlatitude: \(latitude ?? 0), longitude: \(longitude ?? 0)", category: .network)
    } else {
      Loggers.networkSearch.info("케이크 이미지를 불러옵니다.\n검색 키워드: \(keyword ?? "키워드 없음")\nlatitude: \(latitude ?? 0), longitude: \(longitude ?? 0)", category: .network)
    }
    
    return provider.requestPublisher(.fetchCakeImages(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeId: lastCakeId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(CakeImagesResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("케이크 이미지 불러오기에 성공하였습니다.\n불러온 케이크 이미지 갯수: \(decodedData.data.cakeImages.count).", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(CakeImagesResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("케이크 이미지를 불러오는데 실패하였습니다. \(decodedData.data.size)", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImages(category: CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    if lastCakeId != nil {
      Loggers.networkSearch.info("\(category) 카테고리의 케이크 이미지를 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkSearch.info("\(category) 카테고리의 케이크 이미지를 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchCakeImagesByCategory(category.toDTO(), count: count, lastCakeId: lastCakeId))
      .map { $0.data }
      .decode(type: CakeImagesResponseDTO.self, decoder: JSONDecoder())
      .tryMap { response in
        Loggers.networkSearch.info("\(category) 카테고리의 케이크 이미지 불러오기에 성공하였습니다.\n불러온 케이크 이미지 갯수: \(response.data.size)", category: .network)
        return response.toDomain()
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImages(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error> {
    if lastCakeId != nil {
      Loggers.networkSearch.info("ShopId: \(shopId) 의 케이크 이미지를 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkSearch.info("ShopId: \(shopId) 의 케이크 이미지를 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchCakeImagesByShopId(shopId, count: count, lastCakeId: lastCakeId))
      .map { $0.data }
      .decode(type: CakeImagesResponseDTO.self, decoder: JSONDecoder())
      .tryMap { response in
        Loggers.networkSearch.info("ShopId: \(shopId) 의 케이크 이미지를 불러오는데 성공하였습니다.\n불러온 케이크 이미지 갯수: \(response.data.size)", category: .network)
        return response.toDomain()
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchTrendingCakeImages(lastCakeImageId: Int?, pageSize: Int) -> AnyPublisher<[CakeImage], any Error> {
    if lastCakeImageId != nil {
      Loggers.networkSearch.info("인기 케이크 이미지들을 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkSearch.info("인기 케이크 이미지들을 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchTrendingCakeImages(lastCakeId: lastCakeImageId, pageSize: pageSize))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(TrendingCakeImagesResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("인기 케이크 이미지들을 불러오는데 성공하였습니다.불러온 케이크 이미지 갯수: \(decodedData.data.size)", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(TrendingCakeImagesResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("인기 케이크 이미지를 불러오는데 실패하였습니다.", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeShops(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[DomainSearch.CakeShop], any Error> {
    if lastCakeShopId != nil {
      Loggers.networkSearch.info("\(keyword ?? "키워드 없음") 키워드의 케이크샵을 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkSearch.info("\(keyword ?? "키워드 없음") 키워드의 케이크샵을 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchCakeShops(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeShopId: lastCakeShopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(CakeShopsResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("\(keyword ?? "키워드 없음") 키워드의 케이크샵을 불러오는데 성공하였습니다.\n불러온 케이크샵 갯수: \(decodedData.data.size)", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(CakeShopsResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("\(keyword ?? "키워드 없음") 키워드의 케이크샵을 불러오는데 실패하였습니다.", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchLocatedCakeShops(latitude: Double, longitude: Double) -> AnyPublisher<[LocatedCakeShop], any Error> {
    Loggers.networkSearch.info("위치기반 케이크샵을 불러옵니다.", category: .network)
    
    return provider.requestPublisher(.fetchLocatedCakeShops(latitude: latitude, longitude: longitude))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedData = try JSONDecoder().decode(LocatedCakeShopResponseDTO.self, from: response.data)
          Loggers.networkSearch.info("위치기반 케이크샵을 불러오는데 성공하였습니다.\n불러온 케이크샵 갯수: \(decodedData.data.cakeShops.count)", category: .network)
          return decodedData.toDomain()
          
        default:
          let decodedData = try JSONDecoder().decode(LocatedCakeShopResponseDTO.self, from: response.data)
          Loggers.networkSearch.error("위치기반 케이크샵을 불러오는데 실패하였습니다.", category: .network)
          throw SearchNetworkError.customError(for: decodedData.returnCode, message: decodedData.returnMessage)
        }
      }
      .mapError { error in
        Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return error
      }
      .eraseToAnyPublisher()
  }
}
