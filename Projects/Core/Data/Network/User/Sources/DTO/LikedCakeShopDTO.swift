//
//  LikedCakeShopDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

struct LikedCakeShopDTO: Decodable {
  let cakeShopHeartId: Int
  let cakeShopId: Int
  let thumbnailUrl: String
  let cakeShopName: String
  let cakeShopBio: String
  let cakeImageUrls: [String]
  let operationDays: [OperationDayDTO]
}


// MARK: - Mapper

/// DTO -> Domain
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
