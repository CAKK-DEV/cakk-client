//
//  AuthData+MApping.swift
//  NetworkUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public extension AuthData {
  func toDTO() -> AuthRequestDTO {
    return .init(
      provider: provider.toDTO(),
      idToken: idToken,
      nickname: nickname,
      email: email,
      birthday: birthday.toDTO(),
      gender: gender.toDTO())
  }
}
