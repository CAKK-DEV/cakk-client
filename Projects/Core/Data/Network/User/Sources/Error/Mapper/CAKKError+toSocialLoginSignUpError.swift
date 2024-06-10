//
//  NetworkError+toSocialLoginSignUpError.swift
//  NetworkUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension CAKKError {
  func toSocialLoginSignUpError()  -> SocialLoginSignUpError {
    switch self {
    case .customClientError(let clientErrorCode, _):
      if clientErrorCode == .alreadyExistUser {
        return .userAlreadyExists
      }
    case .customServerError:
      return .serverError
    default:
      return .failure
    }
    
    return .failure
  }
}
