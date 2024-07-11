//
//  UserProfileDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

struct UserProfileData: Decodable {
  let profileImageUrl: String?
  let nickname: String
  let email: String
  let gender: GenderDTO
  let birthday: String?
  let role: UserRoleDTO
}


// MARK: - Mapper

/// DTO -> Domain
extension UserProfileData {
  func toDomain() -> UserProfile {
    return .init(profileImageUrl: self.profileImageUrl,
                 nickname: self.nickname,
                 email: self.email,
                 gender: self.gender.toDomain(),
                 birthday: self.birthday?.toDomainDate(),
                 role: self.role.toDomain())
  }
}
