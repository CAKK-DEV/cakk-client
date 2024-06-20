//
//  LikedCakeShopDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct LikedCakeShopDTO: Decodable {
  let cakeShopHeartId: Int
  let cakeShopId: Int
  let thumbnailUrl: String
  let cakeShopName: String
  let cakeShopBio: String
  let cakeImageUrls: [String]
  let operationDays: [OperationDayDTO]
}
