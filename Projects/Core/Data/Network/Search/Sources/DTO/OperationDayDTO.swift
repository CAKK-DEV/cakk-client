//
//  OperationDayDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain
import DomainSearch

enum OperationDayDTO: String, Decodable {
  case sun = "SUN"
  case mon = "MON"
  case tue = "TUE"
  case wed = "WED"
  case thu = "THU"
  case fri = "FRI"
  case sat = "SAT"
}

// MARK: - Mapper

/// DTO -> Domain
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
