//
//  EmailVerificationAPI.swift
//  NetworkUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum EmailVerificationAPI {
  case sendVerificationCode(email: String)
  case confirmVerificationCode(email: String, code: String)
}

extension EmailVerificationAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .sendVerificationCode:
      return "/api/v1/email/request-code"
      
    case .confirmVerificationCode:
      return "/api/v1/email/verify-email"
    }
  }
  
  public var method: Moya.Method {
    return .post
  }
  
  public var task: Moya.Task {
    switch self {
    case .sendVerificationCode(let email):
      let parameters: [String: Any] = [
        "email": email
      ]
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      
    case .confirmVerificationCode(let email, let code):
      let parameters: [String: Any] = [
        "email": email,
        "code": code
      ]
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
  }
  
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
