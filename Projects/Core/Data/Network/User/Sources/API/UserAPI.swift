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
  case signIn(credential: SignInDTO)
  case signOut(accessToken: String, refreshToken: String)
  case fetchUserProfile(accessToken: String)
  case updateUserProfile(newUserProfile: NewUserProfileDTO, accessToken: String)
  case withdraw(accessToken: String)
  case fetchMyShopId(accessToken: String)
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
      
    case .signOut:
      return "/api/v1/sign-out"
      
    case .fetchUserProfile, .updateUserProfile:
      return "/api/v1/me"
      
    case .withdraw:
      return "/api/v1/me"
      
    case .fetchMyShopId:
      return "/api/v1/shops/mine"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp, .signIn, .signOut:
      return .post
      
    case .updateUserProfile:
      return .put
      
    case .fetchUserProfile:
      return .get
      
    case .withdraw:
      return .delete
      
    case .fetchMyShopId:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp(let authRequest):
      return .requestJSONEncodable(authRequest)
      
    case .signIn(let credential):
      return .requestJSONEncodable(credential)
    
    case .signOut:
      return .requestPlain
      
    case .fetchUserProfile:
      return .requestPlain
      
    case .updateUserProfile(let newUserProfile, _):
      return .requestJSONEncodable(newUserProfile)
      
    case .withdraw:
      return .requestPlain
      
    case .fetchMyShopId:
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .signUp, .signIn:
      return ["Content-Type": "application/json"]
      
    case .signOut(let accessToken, let refreshToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)",
        "Refresh": refreshToken
      ]
      
    case .fetchUserProfile(let accessToken),
        .updateUserProfile(_, let accessToken),
        .withdraw(let accessToken),
        .fetchMyShopId(let accessToken):
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
      
    case .signOut:
      return try! Data(contentsOf: Bundle.module.url(forResource: "SignOutSampleResponse", withExtension: "json")!)
      
    case .fetchUserProfile:
      return try! Data(contentsOf: Bundle.module.url(forResource: "UserProfileSampleResponse", withExtension: "json")!)
      
    case .updateUserProfile, .withdraw:
      return try! Data(contentsOf: Bundle.module.url(forResource: "BasicSampleResponse", withExtension: "json")!)
    
    default:
      return Data()
    }
  }
}
