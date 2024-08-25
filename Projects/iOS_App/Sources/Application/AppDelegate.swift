//
//  AppDelegate.swift
//  CAKK
//
//  Created by 이승기 on 7/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import AdManager
import LinkNavigator

class AppDelegate: NSObject, UIApplicationDelegate {
  
  var navigator: LinkNavigator {
    LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    AdManager.initialize()
    
    return true
  }
}
