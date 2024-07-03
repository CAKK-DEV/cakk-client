//
//  CakeShopNetworkError+toDomainError.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopNetworkError {
  func toDomainError() -> CakeShopError {
    return .failure
  }
}
