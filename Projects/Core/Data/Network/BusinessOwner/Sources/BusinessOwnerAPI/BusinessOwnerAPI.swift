//
//  BusinessOwnerAPI.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum BusinessOwnerAPI {
  case requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImageUrl: String, idCardImageUrl: String, contact: String, message: String, accessToken: String)
}

extension BusinessOwnerAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .requestCakeShopOwnerVerification:
      return "/api/v1/shops/certification"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .requestCakeShopOwnerVerification:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .requestCakeShopOwnerVerification(let shopId, let businessRegistrationImageUrl, let idCardImageUrl, let contact, let message, _):
      let params: [String: Any] = [
        "cakeShopId": shopId,
        "businessRegistrationImageUrl": businessRegistrationImageUrl,
        "idCardImageUrl": idCardImageUrl,
        "emergencyContact": contact,
        "message": message
      ]
      return .requestParameters(parameters: params, encoding: JSONEncoding())
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .requestCakeShopOwnerVerification(_, _, _, _, _, let accessToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
}
