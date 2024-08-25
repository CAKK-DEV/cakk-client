//
//  CakeShopDetailRouteBuilder.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonUtil
import LinkNavigator
import DIContainer

import DomainCakeShop
import DomainSearch
import DomainUser

public struct CakeShopDetailRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.ShopDetail.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(CakeShopDetailViewModel.self) { resolver in
        let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
        let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
        let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
        let likeCakeShopUseCase = resolver.resolve(LikeCakeShopUseCase.self)!
        let cakeShopOwnedStateUseCase = resolver.resolve(CakeShopOwnedStateUseCase.self)!
        let myShopIdUseCase = resolver.resolve(MyShopIdUseCase.self)!
        
        return .init(shopId: shopId,
                     cakeShopDetailUseCase: cakeShopDetailUseCase,
                     cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                     cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                     likeCakeShopUseCase: likeCakeShopUseCase,
                     cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                     myShopIdUseCase: myShopIdUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        CakeShopDetailView()
      }
    }
  }
}
