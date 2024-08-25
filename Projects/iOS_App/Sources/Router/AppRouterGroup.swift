//
//  AppRouterGroup.swift
//  CAKK
//
//  Created by 이승기 on 8/22/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import LinkNavigator

import FeatureOnboarding
import FeatureCakeShop
import FeatureUser
import FeatureSearch
import FeatureCakeShopAdmin

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
      TabRouteBuilder()
    ] 
    + FeatureOnboarding.RouterGroup.make()
    + FeatureCakeShopAdmin.RouterGroup.make()
    + FeatureSearch.RouterGroup.make()
    + FeatureCakeShop.RouterGroup.make()
    + FeatureUser.RouterGroup.make()
  }
}
