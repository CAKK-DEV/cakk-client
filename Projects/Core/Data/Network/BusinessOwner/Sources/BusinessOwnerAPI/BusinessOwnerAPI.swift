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
  case requestPresignedUrl
  case uploadPresignedImage(presignedUrl: String, image: Data)
  case requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImageUrl: String, idCardImageUrl: String, contact: String, message: String, accessToken: String)
}

extension BusinessOwnerAPI: TargetType {
  public var baseURL: URL {
    switch self {
    case .uploadPresignedImage(let presignedUrl, _):
      return URL(string: presignedUrl)!
      
    default:
      let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
      return URL(string: baseURLString)!
    }
  }
  
  public var path: String {
    switch self {
    case .requestPresignedUrl:
      return "/api/v1/aws/img"
      
    case .uploadPresignedImage:
      return "" /// Presigned URL은 전체 URL을 제공하므로 별도의 경로가 필요 없습니다.
      
    case .requestCakeShopOwnerVerification:
      return "/api/v1/shops/certification"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .requestPresignedUrl:
      return .get
      
    case .uploadPresignedImage:
      return .put
      
    case .requestCakeShopOwnerVerification:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .requestPresignedUrl:
      return .requestPlain
      
    case .uploadPresignedImage(_, let image):
      return .requestData(image)
      
    case .requestCakeShopOwnerVerification(let shopId, let businessRegistrationImageUrl, let idCardImageUrl, let contact, let message, _):
      let params: [String: Any] = [
        "shopId": shopId,
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
    case .requestPresignedUrl:
      return ["Content-Type": "application/json"]
      
    case .uploadPresignedImage:
      return ["Content-Type": "image/jpeg"]
      
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
