//
//  TrendingCakeShopsResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

struct TrendingCakeShopsResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShops: [CakeShopDTO]
    let lastCakeShopId: Int
    let size: Int
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension TrendingCakeShopsResponseDTO {
  func toDomain() -> [CakeShop] {
    self.data.cakeShops.map { $0.toDomain() }
  }
}
