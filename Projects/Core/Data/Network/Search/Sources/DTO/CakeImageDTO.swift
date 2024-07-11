//
//  CakeImageDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

struct CakeImageDTO: Decodable {
  let cakeShopId: Int
  let cakeId: Int
  let cakeImageUrl: String
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeImageDTO {
  func toDomain() -> CakeImage {
    .init(id: self.cakeId,
          shopId: self.cakeShopId,
          imageUrl: self.cakeImageUrl)
  }
}
