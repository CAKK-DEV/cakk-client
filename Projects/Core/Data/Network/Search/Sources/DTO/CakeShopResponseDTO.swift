//
//  CakeShopResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct CakeShopsResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeShops: [CakeShopDTO]
    let lastCakeShopId: Int?
    let size: Int
  }
}
