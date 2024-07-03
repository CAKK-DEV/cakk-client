//
//  NewCakeImageDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct NewCakeImageDTO: Encodable {
  let cakeImageUrl: String
  let cakeDesignCategories: [CakeCategoryDTO]
  let tagNames: [String]
}
