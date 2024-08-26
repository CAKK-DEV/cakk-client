//
//  RouterGroup.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import LinkNavigator

public struct RouterGroup {
  public static func make() -> [RouteBuilder] {
    [
      CakeShopDetailRouteBuilder(),
      CakeShopQuickInfoRouteBuilder(),
      CategoryRouteBuilder(),
      HomeRouteBuilder(),
      ImageZoomableRouteBuilder()
    ]
  }
}