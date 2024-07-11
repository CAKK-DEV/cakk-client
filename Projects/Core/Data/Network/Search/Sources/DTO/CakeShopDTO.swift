//
//  CakeShopDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

struct CakeShopDTO: Decodable {
  let cakeShopId: Int
  let thumbnailUrl: String?
  let cakeShopName: String
  let cakeShopBio: String?
  let cakeImageUrls: [String]
  let operationDays: [OperationDayWithTimeDTO]
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeShopDTO {
  func toDomain() -> CakeShop {
    return .init(shopId: self.cakeShopId,
                 profileImageUrl: self.thumbnailUrl,
                 name: self.cakeShopName,
                 bio: self.cakeShopBio,
                 cakeImageUrls: self.cakeImageUrls,
                 workingDaysWithTime: self.operationDays.map { $0.toDomain() })
  }
}
