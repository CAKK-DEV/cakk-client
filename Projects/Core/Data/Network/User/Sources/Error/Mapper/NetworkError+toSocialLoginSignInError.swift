//
//  NetworkError+toDomain.swift
//  NetworkUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension NetworkError {
  func toSocialLoginSignInError()  -> SocialLoginSignInError {
    switch self {
    case .customClientError(let clientErrorCode, let string):
      if clientErrorCode == .notExistUser {
        return .newUser
      }
    case .customServerError(let serverErrorCode, let string):
      return .serverError
    default:
      return .failure
    }
    
    return .failure
  }
}
