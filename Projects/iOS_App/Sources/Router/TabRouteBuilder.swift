//
//  TabRouteBuilder.swift
//  CAKK
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

struct TabRouteBuilder: RouteBuilder {
  var matchPath: String { "tab_root" }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        AppTabView()
          .toolbar(.hidden, for: .navigationBar)
      }
    }
  }
}
