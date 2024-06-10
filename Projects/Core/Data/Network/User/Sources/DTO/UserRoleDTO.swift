//
//  UserRoleDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

enum UserRoleDTO: String, Decodable {
  case admin = "ADMIN"
  case businessOwner = "BUSINESS_OWNER"
  case user = "USER"
}
