//
//  CakeShopDetailResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

struct CakeShopDetailResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let cakeShopId: Int
    let cakeShopName: String
    let thumbnailUrl: String?
    var cakeShopBio: String
    var cakeShopDescription: String
    var operationDays: [OperationDayDTO]
    var links: [ExternalLinkDTO]
  }
}


// MARK: - Mapper

/// DTO -> Domain
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
