//
//  ExternalLinkDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

struct ExternalLinkDTO: Codable {
  let linkKind: LinkKind
  let linkPath: String
  
  enum LinkKind: String, Codable {
    case web = "WEB"
    case insta = "INSTAGRAM"
    case kakao = "KAKAOTALK"
  }
}


// MARK: - Mapper

/// DTO -> Domain
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

/// Domain -> DTO
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

extension ExternalShopLink {
  func toDTO() -> ExternalLinkDTO {
    return .init(linkKind: self.linkType.toDTO(),
                 linkPath: self.linkPath)
  }
}
