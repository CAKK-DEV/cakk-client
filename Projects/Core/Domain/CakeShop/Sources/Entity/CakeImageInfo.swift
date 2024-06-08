//
//  CakeImageInfo.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeShopQuickInfo {
  public let shopId: Int
  public let shopName: String
  public let shopBio: String
  public let thumbnailUrl: String
  
  public init(
    shopId: Int,
    shopName: String,
    shopBio: String,
    thumbnailUrl: String
  ) {
    self.shopId = shopId
    self.shopName = shopName
    self.shopBio = shopBio
    self.thumbnailUrl = thumbnailUrl
  }
}
