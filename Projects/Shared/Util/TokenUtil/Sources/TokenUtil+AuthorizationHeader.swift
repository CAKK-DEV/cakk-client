//
//  TokenUtil+AuthorizationHeader.swift
//  TokenUtil
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

extension TokenUtil {
  func getAuthorizationHeader(serviceID: String) -> [String: String]? {
    if let accessToken = self.read(serviceID, account: "accessToken", type: .encryptionKey) {
      return ["Authorization": "Bearer \(accessToken)"]
    } else {
      return nil
    }
  }
}
