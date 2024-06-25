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


// MARK: - Destination

public enum RootDestination: Identifiable {
  public var id: String {
    switch self {
    case .login:
      return "login"
    case .home:
      return "home"
    }
  }
  
  case login
  case home
}


// MARK: - Coordinator

struct AppCoordinator: View {
  
  @StateObject private var router = Router()
  @State private var root: RootDestination = .home
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      switch root {
      case .login:
        AdminLoginView()
      case .home:
        Text("HOme")
      }
    }
    .environmentObject(router)
    .onAppear {
      if UserSession.shared.isSignedIn {
        root = .home
      } else {
        root = .login
      }
    }
    .onChange(of: router.root) { newRoot in
      if let newRoot = newRoot?.destination as? PublicUserAdminDestination {
        switch newRoot {
        case .home:
          self.root = RootDestination.home
        }
      }
    }
  }
}

#Preview {
  AppCoordinator()
}
