//
//  ConfirmVerificationCodeResponseDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct ConfirmVerificationCodeResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
}
