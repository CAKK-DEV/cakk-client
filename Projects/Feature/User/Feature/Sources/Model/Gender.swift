//
//  Gender.swift
//  FeatureUser
//
//  Created by 이승기 on 6/6/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension DomainUser.Gender {
  var displayName: String {
    switch self {
    case .female:
      return "여성"
    case .male:
      return "남성"
    case .unknown:
      return "미공개"
    }
  }
  
  var emoji: String {
    switch self {
    case .female:
      return "🙋‍♀️"
    case .male:
      return "🙋‍♂️"
    case .unknown:
      return "👤"
    }
  }
}
