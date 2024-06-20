//
//  LocatedCakeShopDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct LocatedCakeShopDTO: Decodable {
  let cakeShopId: Int
  let thumbnailUrl: String
  let cakeShopName: String
  let cakeShopBio: String
  let cakeImageUrls: [String]
  let longitude: Double
  let latitude: Double
}
