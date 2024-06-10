//
//  UserAPI.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation
import Moya

public enum UserAPI {
  case signUp(authRequest: AuthRequestDTO)
  case signIn(credential: CredentialDTO)
  case fetchUserProfile(accessToken: String)
  case updateUserProfile(newUserProfile: NewUserProfileDTO, accessToken: String)
}

extension UserAPI: TargetType {
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
      
    case .fetchUserProfile, .updateUserProfile:
      return "/api/v1/me"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp, .signIn, .updateUserProfile:
      return .post
      
    case .fetchUserProfile:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp(let authRequest):
      return .requestJSONEncodable(authRequest)
      
    case .signIn(let credential):
      return .requestJSONEncodable(credential)
      
    case .fetchUserProfile:
      return .requestPlain
      
    case .updateUserProfile(_, let newUserProfile):
      return .requestJSONEncodable(newUserProfile)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .signUp, .signIn:
      return ["Content-Type": "application/json"]
      
    case .fetchUserProfile(let accessToken), .updateUserProfile(_, let accessToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .signUp:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SignUpSampleResponse", withExtension: "json")!)
    
    case .signIn:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SignInSampleResponse", withExtension: "json")!)
      
    case .fetchUserProfile:
      return try! Data(contentsOf: Bundle.module.url(forResource: "UserProfileSampleResponse", withExtension: "json")!)
      
    case .updateUserProfile:
      return try! Data(contentsOf: Bundle.module.url(forResource: "UpdateUserProfileSampleResponse", withExtension: "json")!)
    }
  }
}
