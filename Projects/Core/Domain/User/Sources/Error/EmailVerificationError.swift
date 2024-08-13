//
//  EmailVerificationError.swift
//  DomainUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum EmailVerificationError: Error {
  case wrongVerificationCode
  case serverError
  case failure
}
