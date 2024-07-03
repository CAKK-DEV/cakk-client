//
//  PublicDestination.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum PublicSearchSheetDestination: Identifiable {
  case quickInfo(imageId: Int, cakeImageUrl: String, shopId: Int)
  
  public var id: String {
    switch self {
    case .quickInfo:
      return "ImageDetail"
    }
  }
}

public enum PublicSearchDestination: Hashable {
  case shopDetail(shopId: Int)
}
