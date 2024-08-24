//
//  OnboardingRouteBuilder.swift
//  FeatureOnboarding
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import LinkNavigator
import DIContainer

public struct OnboardingRouteBuilder: RouteBuilder {
  public var matchPath: String { "onboarding" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        OnboardingStepCoordinator()
      }
    }
  }
}
