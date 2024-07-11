//
//  UserRoleDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

enum UserRoleDTO: String, Decodable {
  case admin = "ADMIN"
  case businessOwner = "BUSINESS_OWNER"
  case user = "USER"
}


// MARK: - Mapper

/// DTO -> Domain
extension UserRoleDTO {
  func toDomain() -> UserRole {
    switch self {
    case .admin:
      return .admin
    case .businessOwner:
      return .businessOwner
    case .user:
      return .user
    }
  }
}
