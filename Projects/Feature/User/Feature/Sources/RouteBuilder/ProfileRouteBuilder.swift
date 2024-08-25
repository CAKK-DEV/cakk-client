//
//  ProfileRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import DomainUser

public struct ProfileRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.Profile.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(ProfileViewModel.self) { resolver in
        let userProfileUseCase = resolver.resolve(UserProfileUseCase.self)!
        return .init(userProfileUseCase: userProfileUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return ProfileView()
      }
    }
  }
}

