//
//  AnalyticsServiceImpl.swift
//  CAKK
//
//  Created by 이승기 on 8/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import AnalyticsService
import FirebaseAnalytics

struct AnalyticsServiceImpl: AnalyticsService {
  func logEngagement(view: Any, parameters: [String : Any] = [:]) {
    var baseParameters: [String: Any] = [
      AnalyticsParameterScreenName: "\(type(of: view))",
      AnalyticsParameterScreenClass: "\(type(of: view))"
    ]
    baseParameters.merge(parameters) { (current, _) in current }
    
    Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
  }
  
  func logEvent(name: String, parameters: [String : Any]) {
    Analytics.logEvent(name, parameters: parameters)
  }
  
  func logSignUp(method: SigningMethod) {
    Analytics.logEvent(AnalyticsEventSignUp, parameters: [
      AnalyticsParameterMethod: method.rawValue
    ])
  }
  
  func logSignIn(method: SigningMethod) {
    Analytics.logEvent(AnalyticsEventLogin, parameters: [
      AnalyticsParameterMethod: method.rawValue
    ])
  }
}
