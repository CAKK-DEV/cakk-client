//
//  SocialLoginResponse.swift
//  DomainUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct SocialLoginResponse {
  public let accessToken: String
  public let refreshToken: String
  
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
