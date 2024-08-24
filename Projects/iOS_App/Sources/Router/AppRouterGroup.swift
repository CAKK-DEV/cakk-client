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
      OnboardingRouteBuilder(),
      
      TabRouteBuilder(),
      
      HomeRouteBuilder(),
      CategoryRouteBuilder(),
      CakeShopQuickInfoRouteBuilder(),
      CakeShopDetailRouteBuilder(),
      ImageZoomableRouteBuilder(),
      
      LoginRouteBuilder(),
      SignUpRouteBuilder(),
      SearchMyShopRouteBuilder(),
      ProfileRouteBuilder(),
      EditProfileRouteBuilder(),
      
      MapRouteBuilder(),
      SearchRouteBuilder(),
      
      BusinessCertificationRouteBuilder(),
      
      EditCakeShopBasicInfoRouteBuilder(),
      EditCakeShopImageRouteBuilder(),
      EditCakeShopImageDetailRouteBuilder(),
      NewCakeImageRouteBuilder(),
      EditExternalLinkRouteBuilder(),
      EditWorkingDayRouteBuilder(),
      EditAddressRouteBuilder()
    ]
  }
}
