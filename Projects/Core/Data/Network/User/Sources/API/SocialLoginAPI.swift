//
//  SocialLoginAPI.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation
import Moya

public enum SocialLoginAPI {
  case signUp(authRequest: AuthRequestDTO)
  case signIn(credential: CredentialDTO)
}

extension SocialLoginAPI: TargetType {
  public var baseURL: URL {
    let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    return URL(string: baseURLString)!
  }
  
  public var path: String {
    switch self {
    case .signUp:
      return "/api/v1/sign-up"
      
    case .signIn:
      return "/api/v1/sign-in"
    }
  }
  
  public var method: Moya.Method {
    return .post
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp(let authRequest):
      return .requestJSONEncodable(authRequest)
      
    case .signIn(let credential):
      return .requestJSONEncodable(credential)
    }
  }
  
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
