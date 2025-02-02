//
//  LikedCakeShopsResponseDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

struct LikedCakeShopsResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShops: [LikedCakeShopDTO]
    let lastCakeShopHeartId: Int?
    let size: Int
  }
}

// MARK: - Mapper

/// DTO -> Domain
extension LikedCakeShopsResponseDTO {
  func toDomain() -> [LikedCakeShop] {
    return self.data.cakeShops.map { $0.toDomain() }
  }
}
