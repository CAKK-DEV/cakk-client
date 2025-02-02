//
//  TrendingCakeImagesResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain
import DomainSearch

struct TrendingCakeImagesResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeImages: [CakeImageDTO]
    let size: Int
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension TrendingCakeImagesResponseDTO {
  func toDomain() -> [CakeImage] {
    self.data.cakeImages.map { $0.toDomain() }
  }
}
