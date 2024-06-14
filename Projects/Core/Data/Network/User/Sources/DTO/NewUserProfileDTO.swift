//
//  NewUserProfileDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct NewUserProfileDTO: Codable {
  let profileImageUrl: String?
  let nickname: String
  let email: String
  let gender: GenderDTO
  let birthday: String?
  
  public init(
    profileImageUrl: String?,
    nickname: String,
    email: String,
    gender: GenderDTO,
    birthday: String?
  ) {
    self.profileImageUrl = profileImageUrl
    self.nickname = nickname
    self.email = email
    self.gender = gender
    self.birthday = birthday
  }
}
