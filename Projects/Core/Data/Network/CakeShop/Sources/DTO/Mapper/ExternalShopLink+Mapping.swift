//
//  ExternalShopLink+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension ExternalShopLink {
  func toDTO() -> ExternalLinkDTO {
    return .init(linkKind: self.linkType.toDTO(),
                 linkPath: self.linkPath)
  }
}
