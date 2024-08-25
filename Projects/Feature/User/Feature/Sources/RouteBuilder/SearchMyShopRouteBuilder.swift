//
//  SearchMyShopRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import DomainSearch

public struct SearchMyShopRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.SearchMyShop.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(SearchMyShopViewModel.self) { resolver in
        let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
        return .init(searchCakeShopUseCase: searchCakeShopUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return SearchMyShopView()
      }
    }
  }
}
