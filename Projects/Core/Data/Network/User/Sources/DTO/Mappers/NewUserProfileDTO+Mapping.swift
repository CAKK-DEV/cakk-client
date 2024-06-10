//
//  NewUserProfileDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension NewUserProfile {
  func toDTO() -> NewUserProfileDTO {
    return .init(profileImageUrl: self.profileImageUrl,
                 nickName: self.nickName,
                 email: self.email,
                 gender: self.gender.toDTO(),
                 birthday: self.birthday?.toDTO())
  }
}
