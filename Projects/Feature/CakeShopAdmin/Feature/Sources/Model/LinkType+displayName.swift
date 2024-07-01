//
//  LinkType+displayName.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension ExternalShopLink.LinkType {
  var displayName: String {
    switch self {
    case .web:
      return "웹페이지"
    case .instagram:
      return "인스타그램"
    case .kakaotalk:
      return "카카오톡"
    }
  }
}
