//
//  CredentialData.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation

public struct CredentialData {
  public var loginProvider: LoginProvider
  public var idToken: String
  public var deviceToken: String?
  
  public init(loginProvider: LoginProvider, idToken: String, deviceToken: String? = nil) {
    self.loginProvider = loginProvider
    self.idToken = idToken
    self.deviceToken = deviceToken
  }
}
