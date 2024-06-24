//
//  BusinessAPI.swift
//  NetworkBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum BusinessAPI {
  case uploadCertification(shopId: Int, businessRegistrationImageUrl: String, idCardImageUrl: String, contact: String, message: String, accessToken: String)
  case requestPresignedUrl
  case uploadPresignedImage(presignedUrl: String, image: Data)
}

extension BusinessAPI: TargetType {
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
    case .uploadCertification:
      return "/api/v1/shops/certification"
      
    case .requestPresignedUrl:
      return "/api/v1/aws/img"
      
    case .uploadPresignedImage:
      return "" /// Presigned URL은 전체 URL을 제공하므로 별도의 경로가 필요 없습니다.
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .uploadCertification:
      return .get
      
    case .requestPresignedUrl:
      return .get
      
    case .uploadPresignedImage:
      return .put
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .uploadCertification(let shopId, let businessRegistrationImageUrl, let idCardImageUrl, let contact, let message, _):
      let params: [String: Any] = [
        "shopId": shopId,
        "businessRegistrationImageUrl": businessRegistrationImageUrl,
        "idCardImageUrl": idCardImageUrl,
        "emergencyContact": contact,
        "message": message
      ]
      return .requestParameters(parameters: params, encoding: JSONEncoding())
      
    case .requestPresignedUrl:
      return .requestPlain
      
    case .uploadPresignedImage(_, let image):
      return .requestData(image)
    }
  }
  
  public var headers: [String : String]? {
    switch self {
    case .uploadCertification(_, _, _, _, _, let accessToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
      
    case .requestPresignedUrl:
      return ["Content-Type": "application/json"]
      
    case .uploadPresignedImage:
      return ["Content-Type": "image/jpeg"]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .uploadCertification:
      return try! Data(contentsOf: Bundle.module.url(forResource: "UploadCertificationSampleResponse", withExtension: "json")!)
      
    default:
      return Data()
    }
  }
}
