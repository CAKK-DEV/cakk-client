//
//  CakeCategory+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeCategory {
  func toDTO() -> CakeCategoryDTO {
    switch self {
    case .threeDimensional:
      return .threeDimensional
    case .character:
      return .character
    case .photo:
      return .photo
    case .lunchbox:
      return .lunchbox
    case .figure:
      return .figure
    case .flower:
      return .flower
    case .lettering:
      return .lettering
    case .riceCake:
      return .riceCake
    case .tiara:
      return .tiara
    case .etc:
      return .etc
    }
  }
}
