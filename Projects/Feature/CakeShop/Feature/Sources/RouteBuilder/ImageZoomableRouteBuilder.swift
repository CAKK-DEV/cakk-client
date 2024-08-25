//
//  ImageZoomableRouteBuilder.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

public struct ImageZoomableRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.ImageZoomable.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let imageUrl = items["imageUrl"] else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      let wrappingController = WrappingController(matchPath: matchPath) {
        ImageZoomableView(imageUrl: imageUrl)
      }
      wrappingController.view.backgroundColor = .clear
      
      return wrappingController
    }
  }
}
