//
//  NewUserProfile.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct NewUserProfile {
  public var profileImageUrl: String?
  public var nickName: String
  public var email: String
  public var gender: Gender
  public var birthday: Date?
  
  public init(
    profileImageUrl: String? = nil,
    nickName: String,
    email: String,
    gender: Gender,
    birthday: Date? = nil
  ) {
    self.profileImageUrl = profileImageUrl
    self.nickName = nickName
    self.email = email
    self.gender = gender
    self.birthday = birthday
  }
}