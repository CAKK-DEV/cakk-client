//
//  Category+displayName.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

extension CakeCategory {
  var displayName: String {
    switch self {
    case .threeDimensional:
      return "입체 케이크"
    case .character:
      return "캐릭터"
    case .photo:
      return "포토"
    case .lunchbox:
      return "도시락"
    case .figure:
      return "피규어"
    case .flower:
      return "플라워"
    case .lettering:
      return "레터링"
    case .riceCake:
      return "떡케이크"
    case .tiara:
      return "티아라"
    case .etc:
      return "기타"
    }
  }
}
