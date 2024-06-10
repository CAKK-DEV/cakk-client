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
  let nickName: String
  let email: String
  let gender: GenderDTO
  let birthday: String?
  
  public init(
    profileImageUrl: String?,
    nickName: String,
    email: String,
    gender: GenderDTO,
    birthday: String?
  ) {
    self.profileImageUrl = profileImageUrl
    self.nickName = nickName
    self.email = email
    self.gender = gender
    self.birthday = birthday
  }
}
