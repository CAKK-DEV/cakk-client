//
//  CAKKAppCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/17/24.
//

import SwiftUI

import FeatureOnboarding
import FeatureUser
import FeatureCakeShop

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
}


// MARK: - Coordinator

struct AppCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject private var router = Router()
  @State private var root: RootDestination = .home
  
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
  
  
  // MARK: - Views
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      switch root {
      case .onboarding:
        OnboardingStepCoordinator()
      case .login:
        LoginStepCoordinator() {
          router.replace(with: RootDestination.home)
        }
      case .home:
        AppTabView()
      }
    }
    .fullScreenCover(item: $router.presentedSheet, content: { destination in
      if let destination = destination.destination as? SheetDestination {
        switch destination {
        case .login:
          LoginStepCoordinator(onFinish: {
            router.presentedSheet = nil
          })
        }
      }
    })
    .environmentObject(router)
    .onAppear {
      if hasSeenOnboarding == false {
        router.replace(with: RootDestination.onboarding)
      }
    }
    .onChange(of: router.root) { newRoot in
      if let newRoot = newRoot?.destination as? RootDestination {
        self.root = newRoot
      }
      
      if let newRoot = newRoot?.destination as? OnboardingPublicDestination {
        switch newRoot {
        case .login:
          self.root = RootDestination.login
          
          /// 처음 Login화면에 진입했다는 것은 온보딩을 모두 봤다는 뜻으로 해석할 수 있습니다.
          /// 따라서 root가 Login으로 변경되는 시점에 hasSeenOnboarding 값을 true로 업데이트 합니다.
          hasSeenOnboarding = true
        }
      }
      
      if let newRoot = newRoot?.destination as? PublicUserDestination {
        switch newRoot {
        case .home:
          self.root = RootDestination.home
          
        default:
          break
        }
      }
    }
  }
}


// MARK: - Preview

//#Preview {
//  AppCoordinator()
//}
