//
//  CakeImageDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

extension CakeImageDTO {
  func toDomain() -> CakeImage {
    .init(id: self.cakeId,
          shopId: self.cakeShopId,
          imageUrl: self.cakeImageUrl)
  }
}
