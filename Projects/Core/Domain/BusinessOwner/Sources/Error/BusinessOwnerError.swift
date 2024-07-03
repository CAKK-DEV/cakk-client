//
//  BusinessOwnerError.swift
//  DomainBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum BusinessOwnerError: Error {
  case sessionExpired /// access, refresh 토큰이 모두 만료 되었을 때
  case serverError
  case failure
  case imageUploadFailure
}
