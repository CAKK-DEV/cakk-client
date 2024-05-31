//
//  Gender+Mapping.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import DomainUser

extension Gender {
  public func toDTO() -> GenderDTO {
    switch self {
    case .male:
      return .male
    case .female:
      return .female
    case .unknown:
      return .unknown
    }
  }
}
