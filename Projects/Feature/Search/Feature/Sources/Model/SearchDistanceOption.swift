//
//  SearchDistanceOption.swift
//  FeatureSearch
//
//  Created by 이승기 on 7/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

enum SearchDistanceOption: CaseIterable {
  case oneKilometer
  case threeKilometer
  case tenKilometer
  
  var isAdRequired: Bool {
    switch self {
    case .oneKilometer:
      return false
    case .threeKilometer:
      return false
    case .tenKilometer:
      return true
    }
  }
  
  var displayName: String {
    switch self {
    case .oneKilometer:
      return "1km"
    case .threeKilometer:
      return "3km"
    case .tenKilometer:
      return "6km"
    }
  }
  
  /// 단위는 미터 단위 입니다.
  var distance: Int {
    switch self {
    case .oneKilometer:
      return 1000
    case .threeKilometer:
      return 3000
    case .tenKilometer:
      return 10000
    }
  }
}
