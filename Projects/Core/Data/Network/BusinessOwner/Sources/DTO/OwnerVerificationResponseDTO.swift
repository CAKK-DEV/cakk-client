//
//  OwnerVerificationResponseDTO.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct OwnerVerificationResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
}
