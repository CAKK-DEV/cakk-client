//
//  LikeAPI.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum LikeAPI {
  case fetchLikedCakeShop(lastHeartId: Int?, pageSize: Int, accessToken: String)
  case likeCakeShop(shopId: Int, accessToken: String)
  case unlikeCakeShop(shopId: Int, accessToken: String)
  case fetchLikedCakeShopState(shopId: Int, accessToken: String)
  
  case fetchLikedCakeImage(lastHeartId: Int?, pageSize: Int, accessToken: String)
  case likeCakeImage(imageId: Int, accessToken: String)
  case unlikeCakeImage(imageId: Int, accessToken: String)
  case fetchLikedCakeImageState(imageId: Int, accessToken: String)
}

extension LikeAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .fetchLikedCakeShop:
      return "/api/v1/me/heart-shops"
      
    case .likeCakeShop(let shopId, _), .unlikeCakeShop(let shopId, _):
      return "/api/v1/shops/\(shopId)/like"
      
    case .fetchLikedCakeShopState(let shopId, _):
      return "/api/v1/shops/\(shopId)/heart"
      
    case .fetchLikedCakeImage:
      return "/api/v1/me/heart-cakes"
      
    case .likeCakeImage(let imageId, _), .unlikeCakeImage(let imageId, _):
      return "/api/v1/cakes/\(imageId)/heart"
      
    case .fetchLikedCakeImageState(let imageId, _):
      return "/api/v1/cakes/\(imageId)/heart"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchLikedCakeShop:
      return .get
      
    case .likeCakeShop, .unlikeCakeShop:
      return .put
      
    case .fetchLikedCakeShopState:
      return .get
      
    case .fetchLikedCakeImage:
      return .get
      
    case .likeCakeImage, .unlikeCakeImage:
      return .put
      
    case .fetchLikedCakeImageState:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .fetchLikedCakeShop(let lastHeartId, let pageSize, _):
      var params: [String: Any] = [
        "pageSize": pageSize
      ]
      if let lastHeartId {
        params["cakeShopHeartId"] = lastHeartId
      }
      return .requestParameters(parameters: params, encoding: JSONEncoding())
      
    case .likeCakeShop, .unlikeCakeShop:
      return .requestPlain
      
    case .fetchLikedCakeShopState:
      return .requestPlain
      
    case .fetchLikedCakeImage(let lastHeartId, let pageSize, _):
      var params: [String: Any] = [
        "pageSize": pageSize
      ]
      if let lastHeartId {
        params["cakeHeartId"] = lastHeartId
      }
      return .requestParameters(parameters: params, encoding: JSONEncoding())
      
    case .likeCakeImage, .unlikeCakeImage:
      return .requestPlain
      
    case .fetchLikedCakeImageState:
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .likeCakeShop(_, let accessToken),
        .unlikeCakeShop(_, let accessToken),
        .likeCakeImage(_, let accessToken),
        .unlikeCakeImage(_, let accessToken),
        .fetchLikedCakeShop(_, _, let accessToken),
        .fetchLikedCakeImage(_, _, let accessToken),
        .fetchLikedCakeShopState(_, let accessToken),
        .fetchLikedCakeImageState(_, let accessToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchLikedCakeShop(let shopId, _, _):
      if shopId != nil {
        return try! Data(contentsOf: Bundle.module.url(forResource: "LikedCakeShopSampleResponse2", withExtension: "json")!)
      } else {
        return try! Data(contentsOf: Bundle.module.url(forResource: "LikedCakeShopSampleResponse1", withExtension: "json")!)
      }
      
    case .fetchLikedCakeImage(let imageId, _, _):
      if imageId != nil {
        return try! Data(contentsOf: Bundle.module.url(forResource: "LikedCakeImageSampleResponse2", withExtension: "json")!)
      } else {
        return try! Data(contentsOf: Bundle.module.url(forResource: "LikedCakeImageSampleResponse1", withExtension: "json")!)
      }
      
    case .likeCakeShop, .unlikeCakeShop,
        .likeCakeImage, .unlikeCakeImage:
      return try! Data(contentsOf: Bundle.module.url(forResource: "LikeSampleResponse", withExtension: "json")!)
      
    case .fetchLikedCakeShopState, .fetchLikedCakeImageState:
      return try! Data(contentsOf: Bundle.module.url(forResource: "LikeStateSampleResponse", withExtension: "json")!)
    }
  }
}
