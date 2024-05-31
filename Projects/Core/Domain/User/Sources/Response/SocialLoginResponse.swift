//
//  SocialLoginResponse.swift
//  DomainUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct SocialLoginResponse: Decodable {
  public let returnCode: String
  public let returnMessage: String
  public let data: Data?
  
  public struct Data: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let grantType: String
  }
}
