//
//  UserProfileDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct UserProfileData: Decodable {
  let profileImageUrl: String?
  let nickname: String
  let email: String
  let gender: GenderDTO
  let birthday: String?
  let role: UserRoleDTO
}
