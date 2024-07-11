//
//  CredentialDTO.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import DomainUser

public struct CredentialDTO: Codable {
  let provider: LoginProviderDTO
  let idToken: String
}


// MARK: - Mapper

/// Domain -> DTO
extension CredentialData {
  public func toDTO() -> CredentialDTO {
    return CredentialDTO(provider: self.loginProvider.toDTO(),
                         idToken: self.idToken)
  }
}
