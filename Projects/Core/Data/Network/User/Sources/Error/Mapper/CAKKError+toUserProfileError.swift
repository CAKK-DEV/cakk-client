//
//  CAKKError+toUserProfileError.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension CAKKUserNetworkError {
  func toUserProfileError() -> UserProfileError {
    switch self {
    case .customClientError(let errorCode, _):
      if errorCode == .expiredJwtToken {
        return .sessionExpired
      }
    default:
      return .failure
    }
    
    return .failure
  }
}
