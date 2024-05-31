//
//  CredentialDTO.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation

public struct CredentialDTO: Codable {
  let provider: LoginProviderDTO
  let idToken: String
}
