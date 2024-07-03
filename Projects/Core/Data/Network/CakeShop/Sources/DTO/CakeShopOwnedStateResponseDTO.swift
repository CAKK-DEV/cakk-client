//
//  CakeShopOwnedStateResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct CakeShopOwnedStateResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let isOwned: Bool
  }
}
