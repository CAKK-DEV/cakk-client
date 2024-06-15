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
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchTrendingSearchKeyword:
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
    }
  }
  
  public var headers: [String : String]? {
    switch self {
    case .fetchTrendingSearchKeyword:
      return .none
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchTrendingSearchKeyword:
      return try! Data(contentsOf: Bundle.module.url(forResource: "TrendingSearchKeywordSampleResponse", withExtension: "json")!)
    }
  }
}
