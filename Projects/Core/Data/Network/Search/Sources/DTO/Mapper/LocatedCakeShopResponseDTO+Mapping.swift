//
//  LocatedCakeShopResponseDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

extension LocatedCakeShopResponseDTO {
  func toDomain() -> [LocatedCakeShop] {
    self.data.cakeShops.map { $0.toDomain() }
  }
}
