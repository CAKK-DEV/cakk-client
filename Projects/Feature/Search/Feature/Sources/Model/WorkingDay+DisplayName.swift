//
//  WorkingDay+DisplayName.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

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
