//
//  CakeShopsResponseDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

extension CakeShopsResponseDTO {
  func toDomain() -> [CakeShop] {
    self.data.cakeShops.map { $0.toDomain() }
  }
}
