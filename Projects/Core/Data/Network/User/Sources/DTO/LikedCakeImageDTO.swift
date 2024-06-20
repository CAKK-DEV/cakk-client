//
//  LikedCakeImageDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct LikedCakeImageDTO: Decodable {
  let cakeShopId: Int
  let cakeId: Int
  let cakeHeartId: Int
  let cakeImageUrl: String
}
