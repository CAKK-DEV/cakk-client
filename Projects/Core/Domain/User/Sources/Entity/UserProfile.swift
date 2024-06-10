//
//  UserProfile.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct UserProfile: Equatable {
  public var profileImageUrl: String?
  public var nickname: String
  public var email: String
  public var gender: Gender
  public var birthday: Date?
  public var role: UserRole
  
  public init(
    profileImageUrl: String?,
    nickname: String,
    email: String,
    gender: Gender,
    birthday: Date?, 
    role: UserRole
  ) {
    self.profileImageUrl = profileImageUrl
    self.nickname = nickname
    self.email = email
    self.gender = gender
    self.birthday = birthday
    self.role = role
  }
}
