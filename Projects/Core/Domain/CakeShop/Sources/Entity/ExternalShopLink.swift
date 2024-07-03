//
//  ExternalShopLink.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct ExternalShopLink: Hashable {
  public var linkType: LinkType
  public var linkPath: String
  
  public init(
    linkType: LinkType,
    linkPath: String
  ) {
    self.linkType = linkType
    self.linkPath = linkPath
  }

  public enum LinkType: CaseIterable, Hashable {
    case web
    case instagram
    case kakaotalk
  }
}
