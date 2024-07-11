//
//  CakeShopResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

struct CakeShopsResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShops: [CakeShopDTO]
    let lastCakeShopId: Int?
    let size: Int
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeShopsResponseDTO {
  func toDomain() -> [CakeShop] {
    self.data.cakeShops.map { $0.toDomain() }
  }
}
