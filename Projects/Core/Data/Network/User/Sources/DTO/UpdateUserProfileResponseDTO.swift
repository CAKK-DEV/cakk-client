//
//  UpdateUserProfileResponseDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct UpdateUserProfileResponseDTO: Decodable {
  var returnCode: String
  var returnMessage: String
  var data: Data?
  
  public init(
    returnCode: String,
    returnMessage: String,
    data: Data? = nil
  ) {
    self.returnCode = returnCode
    self.returnMessage = returnMessage
    self.data = data
  }
}
