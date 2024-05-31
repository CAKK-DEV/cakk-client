//
//  OAuthTokenRepository.swift
//  DomainOAuthToken
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public protocol OAuthTokenRepository {
  func saveAccessToken(_ token: String)
  func getAccessToken() -> String?
  func deleteAccessToken()
  
  func saveRefreshToken(_ token: String)
  func getRefreshToken() -> String?
  func deleteRefreshToken()
}
