//
//  SearchDistanceOption.swift
//  FeatureSearch
//
//  Created by 이승기 on 7/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

enum SearchDistanceOption: CaseIterable {
  case fiveHundredMeter
  case oneKilometer
  case threeKilometer
  
  var isAdRequired: Bool {
    switch self {
    case .fiveHundredMeter:
      return false
    case .oneKilometer:
      return false
    case .threeKilometer:
      return true
    }
  }
  
  var displayName: String {
    switch self {
    case .fiveHundredMeter:
      return "500m"
    case .oneKilometer:
      return "1km"
    case .threeKilometer:
      return "3km"
    }
  }
  
  /// 단위는 미터 단위 입니다.
  var distance: Int {
    switch self {
    case .fiveHundredMeter:
      return 500
    case .oneKilometer:
      return 1000
    case .threeKilometer:
      return 3000
    }
  }
}
