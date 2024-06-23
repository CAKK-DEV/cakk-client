//
//  UserRole+UserRole+displayName.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension UserRole {
  var displayName: String {
    switch self {
    case .admin:
      return "어드민"
    case .businessOwner:
      return "사장님"
    case .user:
      return "일반 사용자"
    }
  }
}
