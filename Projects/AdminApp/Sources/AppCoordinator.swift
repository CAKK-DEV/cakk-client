//
//  AppCoordinator.swift
//  CAKK-Admin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import FeatureUserAdmin
import UserSession

import FeatureCakeShopAdmin


// MARK: - Destination

// MARK: - Coordinator

struct AppCoordinator: View {
  
  @StateObject private var router = Router()
  @StateObject var userSession = UserSession.shared
  
  var body: some View {
    AdminHomeView()
      .environmentObject(router)
      .fullScreenCover(isPresented: .constant(!userSession.isSignedIn), content: {
        AdminLoginView()
      })
  }
}

#Preview {
  AppCoordinator()
}
