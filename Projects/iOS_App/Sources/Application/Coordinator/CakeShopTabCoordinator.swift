//
//  CakeShopTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureCakeShop

import FeatureSearch

import FeatureCakeShop
import DomainCakeShop

import DomainUser

import DIContainer
import Router

struct CakeShopTabCoordinator: View {
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopCoordinator()
        .navigationDestination(for: PublicCakeShopDestination.self) { destination in
          switch destination {
          case .map:
            SearchCakeShopOnMapView()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
          }
        }
        .navigationDestination(for: PublicSearchDestination.self) { destination in
          switch destination {
          case .shopDetail(let shopId):
            let _ = diContainer.register(CakeShopDetailViewModel.self) { resolver in
              let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
              let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
              let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
              let likeCakeShopUseCase = resolver.resolve(LikeCakeShopUseCase.self)!
              
              return CakeShopDetailViewModel(shopId: shopId,
                                             cakeShopDetailUseCase: cakeShopDetailUseCase,
                                             cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                             cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                             likeCakeShopUseCase: likeCakeShopUseCase)
            }.inObjectScope(.transient)
            CakeShopDetailCoordinator()
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        }
    }
    .environmentObject(router)
  }
}

#Preview {
  CakeShopTabCoordinator()
}
