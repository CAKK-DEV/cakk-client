//
//  GenderDTO.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import DomainUser

public enum GenderDTO: String, Codable {
  case male = "MALE"
  case female = "FEMALE"
  case unknown = "UNKNOWN"
}


// MARK: - Mapper

/// DTO -> Domain
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

/// Domain -> DTO
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
