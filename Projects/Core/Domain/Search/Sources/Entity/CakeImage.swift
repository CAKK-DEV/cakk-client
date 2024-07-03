//
//  CakeImage.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeImage: Decodable, Identifiable {
  public let id: Int
  public let shopId: Int
  public let imageUrl: String
  
  public init(
    id: Int,
    shopId: Int,
    imageUrl: String)
  {
    self.id = id
    self.shopId = shopId
    self.imageUrl = imageUrl
  }
}
