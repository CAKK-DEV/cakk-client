//
//  CakeShopNetworkError+CakeShopDetailError.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopNetworkError {
  func toCakeShopDetailError() -> CakeShopDetailError {
    switch self {
    case .customClientError(let clientErrorCode, _):
      if clientErrorCode == .notExistCakeShop {
        return .noExists
      } else {
        return .failure
      }
    default:
      return .failure
    }
  }
}
