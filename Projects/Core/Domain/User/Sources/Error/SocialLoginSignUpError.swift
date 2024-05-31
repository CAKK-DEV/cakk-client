//
//  SocialLoginSignUpError.swift
//  DomainUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum SocialLoginSignUpError: Error {
  case failure
  case userAlreadyExists
  case serverError
}
