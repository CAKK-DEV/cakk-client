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
  case fetchCakeImagesByCategory(_ category: CakeCategoryDTO, count: Int, lastCakeId: Int?)
  case fetchCakeImagesByShopId(_ shopId: Int, count: Int, lastCakeId: Int?)
  
  /// cakeImageId파라미터가 있다면 케이크 이미지 조회수를 올립니다
  case fetchCakeShopQuickInfo(shopId: Int, cakeImageId: Int?)
  
  case fetchCakeShopDetail(shopId: Int)
  case fetchAdditionalInfo(shopId: Int)
}

extension CakeShopAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.module.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .fetchCakeImagesByCategory:
      return "/api/v1/cakes/search/categories"
      
    case .fetchCakeImagesByShopId:
      return "/api/v1/cakes/search/shops"
      
    case .fetchCakeShopQuickInfo(let shopId, _):
      return "/api/v1/shops/\(shopId)/simple"
      
    case .fetchCakeShopDetail(let shopId):
      return "/api/v1/shops/\(shopId)"
    
    case .fetchAdditionalInfo(let shopId):
      return "/api/v1/shops/\(shopId)/info"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchCakeImagesByCategory:
      return .get
      
    case .fetchCakeImagesByShopId:
      return .get
      
    case .fetchCakeShopQuickInfo:
      return .get
      
    case .fetchCakeShopDetail:
      return .get
      
    case .fetchAdditionalInfo:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
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
      
    case .fetchCakeShopQuickInfo(_, let cakeImageId):
      var params = [String: Any]()
      if let cakeImageId {
        params["cakeId"] = cakeImageId
      }
      return .requestParameters(parameters: params, encoding: JSONEncoding())
      
    case .fetchCakeShopDetail:
      return .requestPlain
    
    case .fetchAdditionalInfo:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchCakeImagesByCategory(_, _, let lastCakeId),
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
      
    case .fetchCakeShopQuickInfo:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShopQuickInfo", withExtension: "json")!)
      
    case .fetchCakeShopDetail:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleCakeShopDetail", withExtension: "json")!)
      
    case .fetchAdditionalInfo:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SampleAdditionalShopInfo", withExtension: "json")!)
    }
  }
}
