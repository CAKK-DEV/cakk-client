//
//  SignInDTO.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import DomainUser

public struct SignInDTO: Codable {
  let provider: LoginProviderDTO
  let idToken: String
}


// MARK: - Mapper

/// Domain -> DTO
extension CredentialData {
  public func toDTO() -> SignInDTO {
    return SignInDTO(provider: self.loginProvider.toDTO(),
                         idToken: self.idToken)
  }
}

public struct SignOutDTO: Codable {
  let idToken: String
}
