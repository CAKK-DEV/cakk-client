//
//  CakeImagesByCategoryResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct CakeImagesByCategoryResponseDTO: Decodable {
  let code: String
  let message: String
  let data: Data
  
  struct Data: Decodable {
    let cakeImages: [CakeImageDTO]
    let lastCakeId: Int
    let size: Int
  }
}
