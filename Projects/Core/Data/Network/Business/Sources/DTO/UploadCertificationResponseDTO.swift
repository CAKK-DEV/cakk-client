//
//  UploadCertificationResponseDTO.swift
//  NetworkBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct UploadCertificationResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
}
