//
//  CakeShopQuickInfoDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/8/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

struct CakeShopQuickInfoDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShopId: Int
    let thumbnailUrl: String
    let cakeShopName: String
    let cakeShopBio: String
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeShopQuickInfoDTO {
  func toDomain() -> CakeShopQuickInfo {
    return .init(
      shopId: self.data.cakeShopId,
      shopName: self.data.cakeShopName,
      shopBio: self.data.cakeShopBio,
      thumbnailUrl: self.data.thumbnailUrl)
  }
}
