//
//  TrendingCakeShop.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct TrendingCakeShop {
  public let shopId: Int
  public let profileImageUrl: String
  public let name: String
  public let bio: String
  public let cakeImageUrls: [String]
  
  public init(
    shopId: Int,
    profileImageUrl: String,
    name: String,
    bio: String,
    cakeImageUrls: [String]
  ) {
    self.shopId = shopId
    self.profileImageUrl = profileImageUrl
    self.name = name
    self.bio = bio
    self.cakeImageUrls = cakeImageUrls
  }
}
