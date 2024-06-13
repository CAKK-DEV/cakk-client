//
//  CakeShopLocation.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeShopLocation {
  public var address: String
  public var latitude: Double
  public var longitude: Double
  
  public init(
    address: String,
    latitude: Double,
    longitude: Double
  ) {
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
  }
}
