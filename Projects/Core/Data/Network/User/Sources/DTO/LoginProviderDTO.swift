//
//  LoginProviderDTO.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation
import DomainUser

public enum LoginProviderDTO: String, Codable {
  case apple = "APPLE"
  case google = "GOOGLE"
  case Kakao = "KAKAO"
}


// MARK: - Mapper

/// Domain -> DTO
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
