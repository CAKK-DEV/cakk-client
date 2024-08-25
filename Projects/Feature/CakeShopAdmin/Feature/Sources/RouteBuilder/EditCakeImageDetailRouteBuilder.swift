//
//  EditCakeImageDetailRouteBuilder.swift
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

public struct EditCakeShopImageDetailRouteBuilder: RouteBuilder {
  public var matchPath: String { RouteHelper.EditShopImageDetail.path }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let cakeImageIdString = items["cakeImageId"],
            let cakeImageId = Int(cakeImageIdString) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      container.register(EditCakeImageDetailViewModel.self) { resolver in
        let cakeImageDetailUseCase = resolver.resolve(CakeImageDetailUseCase.self)!
        let editCakeImageUseCase = resolver.resolve(EditCakeImageUseCase.self)!
        let deleteCakeImageUseCase = resolver.resolve(DeleteCakeImageUseCase.self)!
        
        return .init(cakeImageId: cakeImageId,
                     cakeImageDetailUseCase: cakeImageDetailUseCase,
                     editCakeImageUseCase: editCakeImageUseCase,
                     deleteCakeImageUseCase: deleteCakeImageUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditCakeImageDetailView()
      }
    }
  }
}


