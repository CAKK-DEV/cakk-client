//
//  LocatedCakeShopResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

struct LocatedCakeShopResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShops: [LocatedCakeShopDTO]
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension LocatedCakeShopResponseDTO {
  func toDomain() -> [LocatedCakeShop] {
    self.data.cakeShops.map { $0.toDomain() }
  }
}
