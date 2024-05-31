//
//  Credential+Mapping.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import DomainUser

extension CredentialData {
  public func toDTO() -> CredentialDTO {
    return CredentialDTO(provider: self.loginProvider.toDTO(),
                         idToken: self.idToken)
  }
}
