//
//  ExternalShopLink+DisplayName.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension ExternalShopLink.LinkType {
  var existsDisplayName: String {
    switch self {
    case .web:
      return "웹 사이트"
    case .instagram:
      return "인스타그램"
    case .kakaotalk:
      return "카카오톡 문의"
    }
  }
  
  var noExistsDisplayName: String {
    switch self {
    case .web:
      return "웹사이트 등록"
    case .instagram:
      return "인스타 등록"
    case .kakaotalk:
      return "카카오톡 등록"
    }
  }
}
