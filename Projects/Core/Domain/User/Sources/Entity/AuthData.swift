//
//  AuthData.swift
//  DomainUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct AuthData {
  public var provider: LoginProvider
  public var idToken: String
  public var deviceToken: String?
  public var nickname: String
  public var email: String
  public var birthday: Date
  public var gender: Gender
  
  public init(
    provider: LoginProvider,
    idToken: String,
    deviceToken: String? = nil,
    nickname: String,
    email: String,
    birthday: Date,
    gender: Gender)
  {
    self.provider = provider
    self.idToken = idToken
    self.deviceToken = deviceToken
    self.nickname = nickname
    self.email = email
    self.birthday = birthday
    self.gender = gender
  }
  
  enum CodingKeys: String, CodingKey {
    case provider, idToken, deviceToken, nickname, email, birthday, gender
  }
}
