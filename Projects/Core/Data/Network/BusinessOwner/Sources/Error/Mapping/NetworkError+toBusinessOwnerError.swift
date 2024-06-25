//
//  NetworkError+toBusinessOwnerError.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainBusinessOwner

public extension BusinessOwnerNetworkError {
  func toBusinessOwnerError()  -> BusinessOwnerError {
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
