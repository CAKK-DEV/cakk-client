//
//  BaseCakeShopNetworkResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct BaseCakeShopNetworkResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
}
