//
//  PublicDestination.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

// TODO: #1 케이크샵 편집 shopId로만 받을 수 있게 API 분리 되면 삭제
import DomainCakeShop
import CommonDomain

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
  
  case editShopBasicInfo(shopDetail: CakeShopDetail)
  case editWorkingDay(shopId: Int, workingDaysWithTime: [WorkingDayWithTime])
  case editLocation(shopId: Int, cakeShopLocation: CakeShopLocation)
  case editExternalLink(shopId: Int, externalLinks: [ExternalShopLink])
  case editCakeImages(shopId: Int)
}
