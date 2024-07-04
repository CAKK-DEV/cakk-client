//
//  LikedCakeShop.swift
//  DomainUser
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

public struct LikedCakeShop {
  public let id: Int
  public let name: String
  public let bio: String
  public let shopHeartId: Int
  public let profileImageUrl: String
  public let cakeImageUrls: [String]
  public let workingDays: [WorkingDay]
  
  public init(
    id: Int,
    name: String,
    bio: String,
    shopHeartId: Int,
    profileImageUrl: String,
    cakeImageUrls: [String],
    workingDays: [WorkingDay]
  ) {
    self.id = id
    self.name = name
    self.bio = bio
    self.shopHeartId = shopHeartId
    self.profileImageUrl = profileImageUrl
    self.cakeImageUrls = cakeImageUrls
    self.workingDays = workingDays
  }
}
