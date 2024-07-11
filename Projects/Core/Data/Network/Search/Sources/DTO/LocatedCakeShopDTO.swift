//
//  LocatedCakeShopDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

struct LocatedCakeShopDTO: Decodable {
  let cakeShopId: Int
  let thumbnailUrl: String
  let cakeShopName: String
  let cakeShopBio: String
  let cakeImageUrls: [String]
  let longitude: Double
  let latitude: Double
}


// MARK: - Mapper

/// DTO -> Domain
extension LocatedCakeShopDTO {
  func toDomain() -> LocatedCakeShop {
    return .init(id: self.cakeShopId,
                 profileImageUrl: self.thumbnailUrl,
                 name: self.cakeShopName,
                 bio: self.cakeShopBio,
                 cakeImageUrls: self.cakeImageUrls,
                 longitude: self.longitude,
                 latitude: self.latitude)
  }
}
