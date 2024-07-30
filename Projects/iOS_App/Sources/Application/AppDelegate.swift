//
//  AppDelegate.swift
//  CAKK
//
//  Created by 이승기 on 7/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import AdManager

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    AdManager.initialize()
    
    return true
  }
}
