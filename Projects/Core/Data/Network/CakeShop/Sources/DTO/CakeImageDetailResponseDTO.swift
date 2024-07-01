//
//  CakeImageDetailResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct CakeImageDetailResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let cakeImageUrl: String
    let cakeShopName: String
    let shopBio: String
    let cakeShopId: Int
    let cakeCategories: [CakeCategoryDTO]
    let tags: [CakeImageTagDTO]
  }
}
