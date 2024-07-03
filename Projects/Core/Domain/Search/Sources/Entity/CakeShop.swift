//
//  CakeShop.swift
//  DomainSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeShop {
  public let shopId: Int
  public let profileImageUrl: String?
  public let name: String
  public let bio: String?
  public let cakeImageUrls: [String]
  public let workingDaysWithTime: [WorkingDayWithTime]
  
  public init(
    shopId: Int,
    profileImageUrl: String?,
    name: String,
    bio: String?,
    cakeImageUrls: [String],
    workingDaysWithTime: [WorkingDayWithTime]
  ) {
    self.shopId = shopId
    self.profileImageUrl = profileImageUrl
    self.name = name
    self.bio = bio
    self.cakeImageUrls = cakeImageUrls
    self.workingDaysWithTime = workingDaysWithTime
  }
}
