//
//  SocialLoginResponseDTO+Mapping.swift
//  NetworkUser
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

extension SocialLoginResponseDTO.Data {
  func toDomain() -> SocialLoginResponse {
    .init(accessToken: self.accessToken,
          refreshToken: self.refreshToken)
  }
}
