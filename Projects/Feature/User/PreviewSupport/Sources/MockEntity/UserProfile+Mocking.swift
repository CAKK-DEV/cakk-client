//
//  UserProfile+Mocking.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension UserProfile {
  static func makeMockUserProfile(role: UserRole) -> UserProfile {
    switch role {
    case .businessOwner:
      return .init(
        profileImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUc4RioVg6PhLayVsjCDWh-XnjUqGoay_rCLopQTDJEGcFqHfP-fuutIssuFwyweq6tDc&usqp=CAU",
        nickname: "비즈니스 케이크샵 이름 케이크샵 이름 케이크샵 이름 케이크샵 이름 케이크샵 이름",
        email: "longlonglonglonglonglonglong@gmaill.com",
        gender: .unknown,
        birthday: .now,
        role: role)
      
    case .admin:
      return .init(
        profileImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUc4RioVg6PhLayVsjCDWh-XnjUqGoay_rCLopQTDJEGcFqHfP-fuutIssuFwyweq6tDc&usqp=CAU",
        nickname: "어드민 계정",
        email: "longlonglonglonglonglonglong@gmaill.com",
        gender: .unknown,
        birthday: .now,
        role: role)
      
    case .user:
      return .init(
        profileImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUc4RioVg6PhLayVsjCDWh-XnjUqGoay_rCLopQTDJEGcFqHfP-fuutIssuFwyweq6tDc&usqp=CAU",
        nickname: "사용자명 사용자명 사용자명 사용자명 사용자명 사용자명 사용자명",
        email: "longlonglonglonglonglonglong@gmaill.com",
        gender: .unknown,
        birthday: .now,
        role: role)
    }
  }
}
