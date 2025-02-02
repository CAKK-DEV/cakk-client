//
//  NetworkError+toDomain.swift
//  NetworkUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension CAKKUserNetworkError {
  func toSocialLoginSignInError()  -> SocialLoginSignInError {
    switch self {
    case .customClientError(let clientErrorCode, _):
      if clientErrorCode == .notExistUser {
        return .newUser
      } else {
        return .failure
      }
    case .customServerError:
      return .serverError
    default:
      return .failure
    }
  }
}
