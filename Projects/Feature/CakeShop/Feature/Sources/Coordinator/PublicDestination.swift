//
//  PublicDestination.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

public enum PublicCakeShopDestination: Hashable {
  case map
  case businessCertification(targetShopId: Int)
  
  // TODO: shopId로 externalLink만 조회 가능하도록 변경되면 externalLinks 파라미터 제거
  case editExternalLink(shopId: Int, externalLinks: [ExternalShopLink])
}

public enum PublicCakeShopSheetDestination: Identifiable {
  case login
  
  public var id: String {
    switch self {
    case .login:
      return "login"
    }
  }
}
