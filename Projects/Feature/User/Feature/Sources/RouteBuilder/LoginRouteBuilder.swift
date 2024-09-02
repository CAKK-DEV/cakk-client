//
//  LoginRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import CommonUtil

import LinkNavigator
import DIContainer

import DomainUser

public struct LoginRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.Login.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(SocialLoginSignInViewModel.self) { resolver in
        let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
        return .init(signInUseCase: signInUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        Login_Root()
      }
    }
  }
}
