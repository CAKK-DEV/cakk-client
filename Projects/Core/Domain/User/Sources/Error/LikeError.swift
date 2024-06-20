//
//  LikeError.swift
//  DomainUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum LikeError: Error {
  case failure
  case sessionExpired
  case serverError
}
