//
//  LikedCakeImageDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension LikedCakeImageDTO {
  func toDomain() -> LikedCakeImage {
    return .init(shopId: self.cakeShopId,
                 imageId: self.cakeId,
                 cakeHeartId: self.cakeHeartId,
                 imageUrl: self.cakeImageUrl
    )
  }
}
