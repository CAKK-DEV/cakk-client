//
//  CakeShopQuickInfoRouteBuilder.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/22/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

import DomainCakeShop
import DomainUser

public struct CakeShopQuickInfoRouteBuilder: RouteBuilder {
  public var matchPath: String { "shop_quick_info" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let imageIdString = items["imageId"],
            let imageId = Int(imageIdString),
            let cakeImageUrl = items["cakeImageUrl"],
            let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(CakeShopQuickInfoViewModel.self) { resolver in
        let cakeQuickInfoUseCase = resolver.resolve(CakeShopQuickInfoUseCase.self)!
        let likeCakeImageUseCase = resolver.resolve(LikeCakeImageUseCase.self)!
        return CakeShopQuickInfoViewModel(
          imageId: imageId,
          cakeImageUrl: cakeImageUrl,
          shopId: shopId,
          cakeQuickInfoUseCase: cakeQuickInfoUseCase,
          likeCakeImageUseCase: likeCakeImageUseCase
        )
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        CakeShopQuickInfoView()
      }
    }
  }
}
