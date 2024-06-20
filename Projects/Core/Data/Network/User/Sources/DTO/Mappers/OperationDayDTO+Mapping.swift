//
//  WorkingDayDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension OperationDayDTO {
  func toDomain() -> WorkingDay {
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
