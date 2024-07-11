//
//  SocialLoginResponseDTO.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import DomainUser

public struct SocialLoginResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  public struct Data: Decodable {
    let accessToken: String
    let refreshToken: String
    let grantType: String
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension SocialLoginResponseDTO.Data {
  func toDomain() -> SocialLoginResponse {
    .init(accessToken: self.accessToken,
          refreshToken: self.refreshToken)
  }
}
