//
//  CakeCategory+DisplayName.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeCategory: Identifiable {
  public var id: String {
    return displayName
  }
  
  var displayName: String {
    switch self {
    case .threeDimensional: "입체"
    case .character: "캐릭터"
    case .photo: "포토"
    case .lunchbox: "도시락"
    case .figure: "피규어"
    case .flower: "플라워"
    case .lettering: "레터링"
    case .riceCake: "떡케이크"
    case .tiara: "티아라"
    case .etc: "기타"
    }
  }
}
