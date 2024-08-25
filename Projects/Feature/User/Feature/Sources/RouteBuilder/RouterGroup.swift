//
//  RouterGroup.swift
//  FeatureUser
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import LinkNavigator

public struct RouterGroup {
  public static func make() -> [RouteBuilder] {
    [
      BusinessCertificationRouteBuilder(),
      EditProfileRouteBuilder(),
      LoginRouteBuilder(),
      ProfileRouteBuilder(),
      SearchMyShopRouteBuilder(),
      SignUpRouteBuilder()
    ]
  }
}
