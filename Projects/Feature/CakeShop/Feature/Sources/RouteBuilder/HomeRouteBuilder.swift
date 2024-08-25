//
//  HomeRouteBuilder.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/22/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

public struct HomeRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.Home.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      DIContainer.shared.container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return CakeShopHomeView()
      }
    }
  }
}
