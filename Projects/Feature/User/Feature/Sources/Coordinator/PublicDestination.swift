//
//  PublicDestination.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum PublicUserSheetDestination: Identifiable {
  case quickInfo(imageId: Int, cakeImageUrl: String, shopId: Int)

  public var id: String {
    switch self {
    case .quickInfo:
      return "ImageDetail"
    }
  }
}

public enum PublicUserDestination: Hashable {
  case shopDetail(shopId: Int)
  case home
  
  case editShopProfile
  case editWorkingDay
  case editLocation
  case editExternalLink
  case editCakeImage
}
