//
//  WorkingDay+DisplayName.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

extension WorkingDay {
  var displayName: String {
    switch self {
    case .mon:
      "월"
    case .tue:
      "화"
    case .wed:
      "수"
    case .thu:
      "목"
    case .fri:
      "금"
    case .sat:
      "토"
    case .sun:
      "일"
    }
  }
}
