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
  case withdraw(accessToken: String)
  case requestPresignedUrl
  case uploadProfileImage(presignedUrl: String, image: Data)
}

extension UserAPI: TargetType {
  public var baseURL: URL {
    switch self {
    case .uploadProfileImage(let presignedUrl, _):
      return URL(string: presignedUrl)!
      
    default:
      let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
      return URL(string: baseURLString)!
    }
  }
  
  public var path: String {
    switch self {
    case .signUp:
      return "/api/v1/sign-up"
      
    case .signIn:
      return "/api/v1/sign-in"
      
    case .fetchUserProfile, .updateUserProfile:
      return "/api/v1/me"
      
    case .withdraw:
      return "/api/v1/me"
      
    case .requestPresignedUrl:
      return "/api/v1/aws/img"
      
    case .uploadProfileImage:
      return ""
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp, .signIn:
      return .post
      
    case .updateUserProfile:
      return .put
      
    case .fetchUserProfile:
      return .get
      
    case .withdraw:
      return .delete
      
    case .requestPresignedUrl:
      return .get
      
    case .uploadProfileImage:
      return .put
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
      
    case .updateUserProfile(let newUserProfile, _):
      return .requestJSONEncodable(newUserProfile)
      
    case .withdraw:
      return .requestPlain
      
    case .requestPresignedUrl:
      return .requestPlain
      
    case .uploadProfileImage(_, let image):
      let params: [String: Any] = [
        "profile_image": image
      ]
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .signUp, .signIn, .requestPresignedUrl, .uploadProfileImage:
      return ["Content-Type": "application/json"]
      
    case .fetchUserProfile(let accessToken),
        .updateUserProfile(_, let accessToken),
        .withdraw(let accessToken):
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
      
    case .updateUserProfile, .withdraw:
      return try! Data(contentsOf: Bundle.module.url(forResource: "BasicSampleResponse", withExtension: "json")!)
    
    case .requestPresignedUrl:
      return Data() /// presigned url mocking is not allowed
    
    case .uploadProfileImage:
      return Data() /// presigned url mocking is not allowed
    }
  }
}
