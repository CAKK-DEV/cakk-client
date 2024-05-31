//
//  LoginProvider+Mapping.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import DomainUser

public extension LoginProvider {
  func toDTO() -> LoginProviderDTO {
    switch self {
    case .apple:
      return .apple
    case .google:
      return .google
    case .kakao:
      return .Kakao
    }
  }
}
