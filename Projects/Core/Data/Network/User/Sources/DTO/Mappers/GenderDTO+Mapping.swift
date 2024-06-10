//
//  GenderDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension GenderDTO {
  func toDomain() -> Gender {
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
