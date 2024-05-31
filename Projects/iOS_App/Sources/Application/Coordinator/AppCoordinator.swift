//
//  CAKKAppCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/17/24.
//

import SwiftUI

import FeatureOnboarding
import FeatureLogin
import Router
import DesignSystem
import DIContainer

// MARK: - Destinations

public enum SheetDestination: Identifiable {
  public var id: String {
    switch self {
    case .login:
      return "login"
    }
  }
  
  case login
}

public enum RootDestination: Identifiable {
  public var id: String {
    switch self {
    case .onboarding:
      return "onboarding"
    case .login:
      return "login"
    case .home:
      return "home"
    }
  }
  
  case onboarding
  case login
  case home
}

private enum Destination: Hashable {
  case login
}


// MARK: - Coordinator

struct AppCoordinator: View {
  
  // MARK: - Properties
  
  private let diConatiner: DIContainerProtocol
  @StateObject private var router = Router()
  
  @State private var root: RootDestination = .home
  
  
  // MARK: - Initializers
  
  init(diContainer: DIContainerProtocol) {
    self.diConatiner = diContainer
  }
  
  
  // MARK: - Views
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      switch root {
      case .onboarding:
        OnboardingStepCoordinator()
      case .login:
        LoginStepCoordinator(diContainer: diConatiner)
      case .home:
        Text("Home")
      }
    }
    .navigationDestination(for: Destination.self) { destination in
      switch destination {
      case Destination.login:
        LoginStepCoordinator(diContainer: diConatiner)
      }
    }
    .fullScreenCover(item: $router.presentedSheet, content: { destination in
      if let destination = destination.destination as? SheetDestination {
        switch destination {
        case .login:
          LoginStepCoordinator(diContainer: diConatiner)
        }
      }
    })
    .environmentObject(router)
    .onAppear {
      router.replace(with: RootDestination.onboarding)
    }
    .onChange(of: router.root) { newRoot in
      if let newRoot = newRoot?.destination as? RootDestination {
        self.root = newRoot
      }
      
      if let newRoot = newRoot?.destination as? OnboardingPublicDestination {
        switch newRoot {
        case .login:
          self.root = RootDestination.login
        }
      }
      
      if let newRoot = newRoot?.destination as? LoginPublicDestination {
        switch newRoot {
        case .home:
          self.root = RootDestination.home
        }
      }
    }
  }
}


// MARK: - Preview

//#Preview {
//  AppCoordinator()
//}
