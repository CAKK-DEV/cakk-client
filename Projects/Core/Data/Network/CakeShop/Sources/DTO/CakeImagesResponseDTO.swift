//
//  CakeImagesResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

struct CakeImagesResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeImages: [CakeImageDTO]
    let lastCakeId: Int?
    let size: Int
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeImagesResponseDTO {
  func toDomain() -> [CakeImage] {
    return self.data.cakeImages.map { .init(id: $0.cakeId, shopId: $0.cakeShopId, imageUrl: $0.cakeImageUrl) }
  }
}
