//
//  CakeImagesByCategoryResponseDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeImagesResponseDTO {
  func toDomain() -> [CakeImage] {
    return self.data.cakeImages.map { .init(id: $0.cakeId, shopId: $0.cakeShopId, imageUrl: $0.cakeImageUrl) }
  }
}
