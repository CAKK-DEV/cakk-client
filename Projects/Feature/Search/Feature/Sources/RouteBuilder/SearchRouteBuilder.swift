//
//  SearchRouteBuilder.swift
//  FeatureSearch
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer
import DomainSearch

public struct SearchRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.Search.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(SearchHistoryViewModel.self) { resolver in
        let searchHistoryUseCase = resolver.resolve(SearchHistoryUseCase.self)!
        return .init(searchHistoryUseCase: searchHistoryUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        SearchView()
      }
    }
  }
}
