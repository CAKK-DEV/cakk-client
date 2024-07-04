//
//  WorkingDay+displayName.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/19/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

extension WorkingDay {
  var displayName: String {
    switch self {
    case .sun:
      return "일"
    case .mon:
      return "월"
    case .tue:
      return "화"
    case .wed:
      return "수"
    case .thu:
      return "목"
    case .fri:
      return "금"
    case .sat:
      return "토"
    }
  }
}
