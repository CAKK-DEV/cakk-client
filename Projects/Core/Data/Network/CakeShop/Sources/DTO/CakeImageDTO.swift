//
//  CakeImageDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct CakeImageDTO: Decodable {
  let cakeShopId: Int
  let cakeId: Int
  let cakeImageUrl: String
}
