//
//  EditWorkingDayRouteBuilder.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import DomainCakeShop

public struct EditWorkingDayRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.EditShopWorkingDay.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(EditWorkingDayViewModel.self) { resolver in
        let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
        let editWorkingDayUseCase = resolver.resolve(EditWorkingDayUseCase.self)!
        return .init(shopId: shopId,
                     cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                     editWorkingDayUseCase: editWorkingDayUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditWorkingDayView()
      }
    }
  }
}
