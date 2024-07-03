//
//  CakeShopDetail.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeShopDetail: Hashable {
  public var shopId: Int
  public var shopName: String
  public var thumbnailImageUrl: String?
  public var shopBio: String
  public var shopDescription: String
  public var workingDays: [WorkingDay]
  public var externalShopLinks: [ExternalShopLink]
  
  public init(
    shopId: Int,
    shopName: String,
    thumbnailImageUrl: String? = nil,
    shopBio: String,
    shopDescription: String,
    workingDays: [WorkingDay],
    externalShopLinks: [ExternalShopLink]
  ) {
    self.shopId = shopId
    self.shopName = shopName
    self.thumbnailImageUrl = thumbnailImageUrl
    self.shopBio = shopBio
    self.shopDescription = shopDescription
    self.workingDays = workingDays
    self.externalShopLinks = externalShopLinks
  }
}
