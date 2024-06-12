//
//  CakeShopAPI.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum CakeShopAPI {
  case fetchCakeImages(category: CakeCategoryDTO, count: Int, lastCakeId: Int?)
  case fetchCakeShopQuickInfo(shopId: Int)
  case fetchCakeShopDetail(shopId: Int)
}

extension CakeShopAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.module.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .fetchCakeImages:
      return "/api/v1/cakes/search/categories"
      
    case .fetchCakeShopQuickInfo(let shopId):
      return "/api/v1/shops/\(shopId)/simple"
      
    case .fetchCakeShopDetail(let shopId):
      return "/api/v1/shops/\(shopId)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchCakeImages:
      return .get
      
    case .fetchCakeShopQuickInfo:
      return .get
      
    case .fetchCakeShopDetail:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .fetchCakeImages(let category, let count, let lastCakeId):
      var params: [String: Any] = [
        "category": category.rawValue,
        "pageSize": count
      ]
      if let lastCakeId {
        params["cakeId"] = lastCakeId
      }
      
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeShopQuickInfo:
      return .requestPlain
      
    case .fetchCakeShopDetail:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchCakeImages(_, _, let lastCakeId):
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
      
    case .fetchCakeShopQuickInfo:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShopQuickInfo", withExtension: "json")!)
      
    case .fetchCakeShopDetail(shopId: let shopId):
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShopDetail", withExtension: "json")!)
    }
  }
}
