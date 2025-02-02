//
//  SearchAPI.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum SearchAPI {
  case fetchTrendingSearchKeyword(count: Int)
  case fetchTrendingCakeShops(count: Int)
  
  case fetchCakeImages(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeId: Int?)
  case fetchTrendingCakeImages(lastCakeId: Int?, pageSize: Int)
  case fetchCakeShops(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?)
  case fetchLocatedCakeShops(distance: Int, latitude: Double, longitude: Double)
  case fetchCakeImagesByCategory(_ category: CakeCategoryDTO, count: Int, lastCakeId: Int?)
  case fetchCakeImagesByShopId(_ shopId: Int, count: Int, lastCakeId: Int?)
}

extension SearchAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .fetchTrendingSearchKeyword:
      return "/api/v1/search/top-searched"
      
    case .fetchTrendingCakeShops:
      return "/api/v1/shops/search/views"
      
    case .fetchCakeImages:
      return "/api/v1/cakes/search/cakes"
      
    case .fetchTrendingCakeImages:
      return "/api/v1/cakes/search/views"
      
    case .fetchCakeShops:
      return "/api/v1/shops/search/shops"
      
    case .fetchLocatedCakeShops:
      return "/api/v1/shops/location-based"
      
    case .fetchCakeImagesByCategory:
      return "/api/v1/cakes/search/categories"
      
    case .fetchCakeImagesByShopId:
      return "/api/v1/cakes/search/shops"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchTrendingSearchKeyword:
      return .get
      
    case .fetchTrendingCakeShops:
      return .get
    
    case .fetchCakeImages:
      return .get
      
    case .fetchTrendingCakeImages:
      return .get
      
    case .fetchCakeShops:
      return .get
      
    case .fetchLocatedCakeShops:
      return .get
      
    case .fetchCakeImagesByCategory:
      return .get
      
    case .fetchCakeImagesByShopId:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .fetchTrendingSearchKeyword(let count):
      let params: [String: Any] = [
        "count": count
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchTrendingCakeShops(let count):
      let params: [String: Any] = [
        "pageSize": count
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeImages(let keyword, let latitude, let longitude, let pageSize, let lastCakeId):
      var params: [String: Any] = [
        "pageSize": pageSize
      ]
      if let keyword { params["keyword"] = keyword }
      if let lastCakeId { params["cakeId"] = lastCakeId }
      if let latitude, let longitude {
        params["latitude"] = latitude
        params["longitude"] = longitude
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchTrendingCakeImages(let lastCakeId, let pageSize):
      var params: [String: Any] = [
        "pageSize": pageSize
      ]
      if let lastCakeId {
        params["offset"] = lastCakeId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeShops(let keyword, let latitude, let longitude, let pageSize, let lastCakeShopId):
      var params: [String: Any] = [
        "pageSize": pageSize
      ]
      if let keyword { params["keyword"] = keyword }
      if let lastCakeShopId { params["cakeShopId"] = lastCakeShopId }
      if let latitude, let longitude {
        params["latitude"] = latitude
        params["longitude"] = longitude
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchLocatedCakeShops(let distance, let latitude, let longitude):
      let params: [String: Any] = [
        "distance": distance,
        "latitude": latitude,
        "longitude": longitude
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeImagesByCategory(let category, let count, let lastCakeId):
      var params: [String: Any] = [
        "category": category.rawValue,
        "pageSize": count
      ]
      if let lastCakeId {
        params["cakeId"] = lastCakeId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeImagesByShopId(let shopId, let count, let lastCakeId):
      var params: [String: Any] = [
        "cakeShopId": shopId,
        "pageSize": count
      ]
      if let lastCakeId {
        params["cakeId"] = lastCakeId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
  }
  
  public var headers: [String : String]? {
    return .none
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchTrendingSearchKeyword:
      return try! Data(contentsOf: Bundle.module.url(forResource: "TrendingSearchKeywordSampleResponse", withExtension: "json")!)
      
    case .fetchTrendingCakeShops:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeImages1", withExtension: "json")!)
      
    case .fetchCakeImages(_, _, _, _, let lastCakeId),
        .fetchTrendingCakeImages(let lastCakeId, _),
        .fetchCakeImagesByCategory(_, _, let lastCakeId),
        .fetchCakeImagesByShopId(_, _, let lastCakeId):
      if let lastCakeId {
        switch lastCakeId {
        case 10:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeImages2", withExtension: "json")!)
        case 20:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeImages3", withExtension: "json")!)
        default:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeImages4", withExtension: "json")!)
        }
      } else {
        return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeImages1", withExtension: "json")!)
      }
      
    case .fetchCakeShops(_, _, _, _, let lastCakeShopId):
      if let lastCakeShopId {
        switch lastCakeShopId {
        case 6:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShops2", withExtension: "json")!)
        case 12:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShops3", withExtension: "json")!)
        default:
          return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShops4", withExtension: "json")!)
        }
      } else {
        return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShops1", withExtension: "json")!)
      }
   
    case .fetchLocatedCakeShops:
      return try! Data(contentsOf: Bundle.module.url(forResource: "LocatedCakeShopSampleResponse", withExtension: "json")!)
    }
  }
}
