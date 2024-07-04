//
//  WorkingDaysWithTime+WorkingDay.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import CommonDomain
import DesignSystem
import DomainSearch

extension WorkingDayWithTime {
  func toWorkingDay() -> CakeShopThumbnailView.WorkingDay {
    switch workingDay {
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
