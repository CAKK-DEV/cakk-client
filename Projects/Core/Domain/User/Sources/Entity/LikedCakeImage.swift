//
//  LikedCakeImage.swift
//  DomainUser
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct LikedCakeImage: Identifiable, Equatable {
  public let shopId: Int
  public let imageId: Int
  public let cakeHeartId: Int
  public let imageUrl: String
  
  public init(
    shopId: Int,
    imageId: Int,
    cakeHeartId: Int,
    imageUrl: String
  ) {
    self.shopId = shopId
    self.imageId = imageId
    self.cakeHeartId = cakeHeartId
    self.imageUrl = imageUrl
  }
  
  public var id: Int {
    return imageId
  }
}
