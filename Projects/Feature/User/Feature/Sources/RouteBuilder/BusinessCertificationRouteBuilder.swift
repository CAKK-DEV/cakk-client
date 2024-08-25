//
//  BusinessCertificationRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import DomainBusinessOwner

public struct BusinessCertificationRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.BusinessCertification.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(BusinessCertificationViewModel.self) { resolver in
        let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
        return .init(targetShopId: shopId, cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return BusinessCertificationView()
      }
    }
  }
}

