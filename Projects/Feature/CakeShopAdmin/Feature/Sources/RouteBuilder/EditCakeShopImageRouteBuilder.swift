//
//  EditCakeShopImageRouteBuilder.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

import DomainSearch

public struct EditCakeShopImageRouteBuilder: RouteBuilder {
  public var matchPath: String { "edit_shop_image" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(EditCakeShopImagesViewModel.self) { resolver in
        let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
        return .init(shopId: shopId, cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditCakeShopImagesView()
      }
    }
  }
}

