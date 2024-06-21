//
//  LikeTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//


import SwiftUI
import SwiftUIUtil

import FeatureUser
import DomainUser

import FeatureCakeShop
import DomainCakeShop

import Router
import DIContainer

struct LikeTabCoordinator: View {
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      LikeCoordinator()
        .sheet(item: $router.presentedSheet) { sheet in
          if let destination = sheet.destination as? FeatureUser.PublicSheetDestination {
            switch destination {
            case .quickInfo(let imageId, let cakeImageUrl, let shopId):
              let _ = diContainer.register(CakeShopQuickInfoViewModel.self) { resolver in
                let cakeQuickInfoUseCase = resolver.resolve(CakeShopQuickInfoUseCase.self)!
                let likeCakeImageUseCase = resolver.resolve(LikeCakeImageUseCase.self)!
                return CakeShopQuickInfoViewModel(imageId: imageId,
                                                  cakeImageUrl: cakeImageUrl,
                                                  shopId: shopId,
                                                  cakeQuickInfoUseCase: cakeQuickInfoUseCase,
                                                  likeCakeImageUseCase: likeCakeImageUseCase)
              }
              CakeShopQuickInfoView()
            }
          }
        }
        .navigationDestination(for: FeatureCakeShop.Destination.self) { destination in
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
            CakeShopDetailView()
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          
          case .categoryDetail:
            EmptyView()
          }
        }
        .navigationDestination(for: PublicDestination.self, destination: { destination in
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
            CakeShopDetailView()
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        })
        .fullScreenCover(item: $router.presentedFullScreenSheet, content: { sheet in
          if let destination = sheet.destination as? FeatureCakeShop.FullScreenSheetDestination {
            switch destination {
            case .imageFullScreen(let imageUrl):
              ImageZoomableView(imageUrl: imageUrl)
                .background(ClearBackgroundView())
            }
          }
        })
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  CakeShopTabCoordinator()
}

