//
//  OwnerVerificationResponseDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct OwnerVerificationResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
}
