//
//  ImageUploadAPI.swift
//  NetworkImage
//
//  Created by 이승기 on 7/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum ImageUploadAPI {
  case requestPresignedUrl
  case uploadPresignedImage(presignedUrl: String, image: Data)
}

extension ImageUploadAPI: TargetType {
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
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .requestPresignedUrl:
      return .get
      
    case .uploadPresignedImage:
      return .put
    }
  }
  
  public var task: Task {
    switch self {
    case .requestPresignedUrl:
      return .requestPlain
      
    case .uploadPresignedImage(_, let image):
      return .requestData(image)
    }
  }
  
  public var headers: [String : String]? {
    switch self {
    case .requestPresignedUrl:
      return ["Content-Type": "application/json"]
      
    case .uploadPresignedImage(let presignedUrl, let image):
      return ["Content-Type": "image/jpeg"]
    }
  }
}
