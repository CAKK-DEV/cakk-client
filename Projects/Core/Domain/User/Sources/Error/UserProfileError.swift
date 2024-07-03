//
//  UserProfileError.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum UserProfileError: Error {
  case notSignedIn // 로그인하지 않은 상태로 접근할 때
  case sessionExpired // access, refresh 토큰이 모두 만료 되었을 때
  case serverError
  case imageUploadFailure
  case failure
}
