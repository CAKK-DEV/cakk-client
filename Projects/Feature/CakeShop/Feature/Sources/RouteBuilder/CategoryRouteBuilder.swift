//
//  CategoryRouteBuilder.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/22/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import CommonDomain
import DomainCakeShop
import DomainSearch

public struct CategoryRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.Category.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let categoryRawValue = items["category"],
            let category = CakeCategory(rawValue: categoryRawValue) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      
      container.register(CakeCategoryImageListViewModel.self) { resolver in
        let useCase = resolver.resolve(CakeImagesByCategoryUseCase.self)!
        return .init(category: category, useCase: useCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        CakeCategoryView(category: category)
      }
    }
  }
}

