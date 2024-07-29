//
//  AdManager.swift
//  AdManager
//
//  Created by 이승기 on 7/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import GoogleMobileAds

public struct AdManager {
  public init() { }
  
  static public func initialize() {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }
}
