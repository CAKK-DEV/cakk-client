//
//  CAKKUserNetworkError+LikeError.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension CAKKUserNetworkError {
  func toLikeError() -> LikeError {
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
