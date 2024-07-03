//
//  CakeShopQuickInfoDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/8/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopQuickInfoDTO {
  func toDomain() -> CakeShopQuickInfo {
    return .init(
      shopId: self.data.cakeShopId,
      shopName: self.data.cakeShopName,
      shopBio: self.data.cakeShopBio,
      thumbnailUrl: self.data.thumbnailUrl)
  }
}
