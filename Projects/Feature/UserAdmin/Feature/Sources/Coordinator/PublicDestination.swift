//
//  PublicDestination.swift
//  FeatureUserAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum PublicUserAdminDestination: Identifiable {
  case home
  
  public var id: String {
    switch self {
    case .home:
      return "home"
    }
  }
}
