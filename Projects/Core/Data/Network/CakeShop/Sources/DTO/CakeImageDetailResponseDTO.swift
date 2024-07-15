//
//  CakeImageDetailResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

struct CakeImageDetailResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let cakeImageUrl: String
    let cakeShopName: String
    let shopBio: String
    let cakeShopId: Int
    let cakeCategories: [CakeCategoryDTO]
    let tags: [CakeImageTagDTO]
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeImageDetailResponseDTO.Data {
  func toDomain() -> CakeImageDetail {
    return .init(shopId: self.cakeShopId,
                 imageUrl: self.cakeImageUrl,
                 shopBio: self.shopBio,
                 categories: self.cakeCategories.map { $0.toDomain() },
                 tags: self.tags.map { $0.tagName })
  }
}
