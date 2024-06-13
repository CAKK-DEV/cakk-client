//
//  CakeShopDetailDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopDetailResponseDTO.Data {
  func toDomain() -> CakeShopDetail {
    .init(shopId: self.cakeShopId,
          shopName: self.cakeShopName,
          thumbnailImageUrl: self.thumbnailUrl,
          shopBio: self.cakeShopBio,
          shopDescription: self.cakeShopDescription,
          workingDays: self.operationDays.map { $0.toDomain() },
          externalShopLinks: self.links.map { $0.toDomain() })
  }
}
