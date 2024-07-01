//
//  LinkKind+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension ExternalShopLink.LinkType {
  func toDTO() -> ExternalLinkDTO.LinkKind {
    switch self {
    case .web:
      return .web
    case .instagram:
      return .insta
    case .kakaotalk:
      return .kakao
    }
  }
}
