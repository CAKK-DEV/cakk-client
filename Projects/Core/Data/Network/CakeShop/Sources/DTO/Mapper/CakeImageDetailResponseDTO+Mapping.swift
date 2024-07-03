//
//  CakeImageDetailResponseDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeImageDetailResponseDTO.Data {
  func toDomain() -> CakeImageDetail {
    return .init(shopId: self.cakeShopId,
                 imageUrl: self.cakeImageUrl,
                 shopBio: self.shopBio,
                 categories: self.cakeCategories.map { $0.toDomain() },
                 tags: self.tags.map { $0.tagName })
  }
}
