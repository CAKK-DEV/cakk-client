//
//  BusinessNetworkError+toUploadCertificationError.swift
//  NetworkBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainBusiness

public extension BusinessNetworkError {
  func toUploadCertificationError() -> UploadCertificationError {
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

