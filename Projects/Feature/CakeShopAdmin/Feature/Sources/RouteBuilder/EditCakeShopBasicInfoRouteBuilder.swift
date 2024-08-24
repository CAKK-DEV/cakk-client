//
//  EditCakeShopBasicInfoRouteBuilder.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

import DomainCakeShop

public struct EditCakeShopBasicInfoRouteBuilder: RouteBuilder {
  public var matchPath: String { "edit_shop_basic_info" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(EditCakeShopBasicInfoViewModel.self) { resolver in
        let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
        let editShopBasicInfoUseCase = resolver.resolve(EditShopBasicInfoUseCase.self)!
        return .init(shopId: shopId, 
                     cakeShopDetailUseCase: cakeShopDetailUseCase,
                     editShopBasicInfoUseCase: editShopBasicInfoUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditCakeShopBasicInfoView()
      }
    }
  }
}

