//
//  EditAddressRouteBuilder.swift
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

public struct EditAddressRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.EditShopAddress.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let shopIdString = items["shopId"],
            let shopId = Int(shopIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(EditCakeShopAddressViewModel.self) { resolver in
        let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
        let editShopAddressUseCase = resolver.resolve(EditShopAddressUseCase.self)!
        return .init(shopId: shopId,
                     cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                     editShopAddressUseCase: editShopAddressUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditCakeShopAddressView()
      }
    }
  }
}
