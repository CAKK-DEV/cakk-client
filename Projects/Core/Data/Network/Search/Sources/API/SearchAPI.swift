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
  case fetchCakeImages(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeId: Int?)
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
      
    case .fetchCakeImages:
      return "/api/v1/cakes/search/cakes"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchTrendingSearchKeyword:
      return .get
    
    case .fetchCakeImages:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .fetchTrendingSearchKeyword(let count):
      let params: [String: Any] = [
        "count": count
      ]
      return .requestParameters(parameters: params, encoding: JSONEncoding())
      
    case .fetchCakeImages(let keyword, let latitude, let longitude, let pageSize, let lastCakeId):
      var params: [String: Any] = [
        "latitude": latitude,
        "longitude": longitude,
        "pageSize": pageSize
      ]
      if let keyword { params["keyword"] = keyword }
      if let lastCakeId { params["cakeId"] = lastCakeId }
      return .requestParameters(parameters: params, encoding: JSONEncoding())
    }
  }
  
  public var headers: [String : String]? {
    return .none
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchTrendingSearchKeyword:
      return try! Data(contentsOf: Bundle.module.url(forResource: "TrendingSearchKeywordSampleResponse", withExtension: "json")!)
      
    case .fetchCakeImages(_, _, _, _, let lastCakeId):
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
    }
  }
}