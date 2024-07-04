//
//  CakeCategory+Emoji.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

extension CakeCategory {
  var emoji: String {
    switch self {
    case .threeDimensional: "🐰"
    case .character: "🧸"
    case .photo: "📷"
    case .lunchbox: "🍱"
    case .figure: "🤖"
    case .flower: "🌷"
    case .lettering: "✍️"
    case .riceCake: "🍚"
    case .tiara: "👑"
    case .etc: "🍰"
    }
  }
}
