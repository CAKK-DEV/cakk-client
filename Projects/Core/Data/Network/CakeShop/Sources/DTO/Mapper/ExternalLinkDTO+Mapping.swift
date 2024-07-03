//
//  ExternalLinkDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension ExternalLinkDTO {
  func toDomain() -> ExternalShopLink {
    .init(linkType: self.linkKind.toDomain(),
          linkPath: self.linkPath)
  }
}

extension ExternalLinkDTO.LinkKind {
  func toDomain() -> ExternalShopLink.LinkType {
    switch self {
    case .web:
      return .web
    case .insta:
      return .instagram
    case .kakao:
      return .kakaotalk
    }
  }
}
