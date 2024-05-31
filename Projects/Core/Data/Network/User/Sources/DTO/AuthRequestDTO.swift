//
//  AuthRequestDTO.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation

public struct AuthRequestDTO: Codable {
  var provider: LoginProviderDTO
  var idToken: String
  var deviceToken: String?
  var nickname: String
  var email: String
  var birthday: String
  var gender: GenderDTO
  
  enum CodingKeys: String, CodingKey {
    case provider, idToken, deviceToken, nickname, email, birthday, gender
  }
}
