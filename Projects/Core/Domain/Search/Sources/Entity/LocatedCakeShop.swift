//
//  LocatedCakeShop.swift
//  DomainSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct LocatedCakeShop: Identifiable, Equatable, Hashable {
  public let id: Int
  public let profileImageUrl: String?
  public let name: String
  public let bio: String
  public let cakeImageUrls: [String]
  public let longitude: Double
  public let latitude: Double
  
  public init(
    id: Int,
    profileImageUrl: String?,
    name: String,
    bio: String,
    cakeImageUrls: [String],
    longitude: Double,
    latitude: Double
  ) {
    self.id = id
    self.profileImageUrl = profileImageUrl
    self.name = name
    self.bio = bio
    self.cakeImageUrls = cakeImageUrls
    self.longitude = longitude
    self.latitude = latitude
  }
}
