//
//  AnalyticsService.swift
//  AnalyticsService
//
//  Created by 이승기 on 8/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public protocol AnalyticsService {
  func logEngagement(view: Any, parameters: [String: Any])
  func logEvent(name: String, parameters: [String: Any])
  func logSignUp(method: SigningMethod)
  func logSignIn(method: SigningMethod)
}

public extension AnalyticsService {
  func logEngagement(view: Any, parameters: [String: Any] = [:]) {
    logEngagement(view: view, parameters: parameters)
  }
}
