//
//  CakeImageDetail.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeImageDetail: Equatable {
  public var shopId: Int
  public var imageUrl: String
  public var shopBio: String
  public var categories: [CakeCategory]
  public var tags: [String]
  
  public init(
    shopId: Int,
    imageUrl: String,
    shopBio: String,
    categories: [CakeCategory],
    tags: [String]
  ) {
    self.shopId = shopId
    self.imageUrl = imageUrl
    self.shopBio = shopBio
    self.categories = categories
    self.tags = tags
  }
}
