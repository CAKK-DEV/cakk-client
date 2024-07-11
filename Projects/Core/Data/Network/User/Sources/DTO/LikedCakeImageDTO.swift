//
//  LikedCakeImageDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

struct LikedCakeImageDTO: Decodable {
  let cakeShopId: Int
  let cakeId: Int
  let cakeHeartId: Int
  let cakeImageUrl: String
}


// MARK: - Mapper

/// DTO -> Domain
extension LikedCakeImageDTO {
  func toDomain() -> LikedCakeImage {
    return .init(shopId: self.cakeShopId,
                 imageId: self.cakeId,
                 cakeHeartId: self.cakeHeartId,
                 imageUrl: self.cakeImageUrl
    )
  }
}
