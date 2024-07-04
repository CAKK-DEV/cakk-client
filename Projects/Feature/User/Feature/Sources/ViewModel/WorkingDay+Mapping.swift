//
//  WorkingDay+Mapping.swift
//  FeatureUser
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import DesignSystem
import CommonDomain

extension WorkingDay {
  func mapping() -> CakeShopThumbnailView.WorkingDay {
    switch self {
    case .sun:
      return .sun
    case .mon:
      return .mon
    case .tue:
      return .tue
    case .wed:
      return .wed
    case .thu:
      return .thu
    case .fri:
      return .fri
    case .sat:
      return .sat
    }
  }
}
