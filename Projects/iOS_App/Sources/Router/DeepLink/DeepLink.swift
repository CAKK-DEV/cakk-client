//
//  DeepLink.swift
//  CAKK
//
//  Created by 이승기 on 8/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct DeepLink {
  let host: String
  let queryItems: [URLQueryItem]
  
  init?(url: URL) {
    guard let host = url.host else { return nil }
    self.host = host
    self.queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
  }
  
  func value(for queryItem: String) -> String? {
    return queryItems.first { $0.name == queryItem }?.value
  }
}
