//
//  LikedCakeShopsResponseDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension LikedCakeShopsResponseDTO {
  func toDomain() -> [LikedCakeShop] {
    return self.data.cakeShops.map { $0.toDomain() }
  }
}

extension LikedCakeShopDTO {
  func toDomain() -> LikedCakeShop {
    .init(id: self.cakeShopId,
          name: self.cakeShopName,
          bio: self.cakeShopBio,
          shopHeartId: self.cakeShopHeartId,
          profileImageUrl: self.thumbnailUrl,
          cakeImageUrls: self.cakeImageUrls,
          workingDays: self.operationDays.map { $0.toDomain() }
    )
  }
}
