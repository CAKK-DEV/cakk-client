//
//  SearchTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil

import Router
import DIContainer

import FeatureSearch

import FeatureCakeShop
import DomainCakeShop

import FeatureUser
import DomainBusinessOwner

import DomainUser

struct SearchTabCoordinator: View {
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      SearchCoordinator()
        .sheet(item: $router.presentedSheet) { sheet in
          if let destination = sheet.destination as? PublicSearchSheetDestination {
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
        .navigationDestination(for: PublicSearchDestination.self) { destination in
          switch destination {
          case .shopDetail(let shopId):
            let _ = diContainer.register(CakeShopDetailViewModel.self) { resolver in
              let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
              let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
              let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
              let likeCakeShopUseCase = resolver.resolve(LikeCakeShopUseCase.self)!
              let cakeShopOwnedStateUseCase = resolver.resolve(CakeShopOwnedStateUseCase.self)!
              let myShopIdUseCase = resolver.resolve(MyShopIdUseCase.self)!
              
              return CakeShopDetailViewModel(shopId: shopId,
                                             cakeShopDetailUseCase: cakeShopDetailUseCase,
                                             cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                             cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                             likeCakeShopUseCase: likeCakeShopUseCase,
                                             cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                                             myShopIdUseCase: myShopIdUseCase)
            }.inObjectScope(.transient)
            CakeShopDetailCoordinator()
              .navigationDestination(for: PublicCakeShopDestination.self) { destination in
                if case .businessCertification(targetShopId: let targetShopId) = destination {
                  let _ = diContainer.register(BusinessCertificationViewModel.self) { resolver in
                    let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
                    return BusinessCertificationViewModel(
                      targetShopId: targetShopId,
                      cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
                  }
                  
                  BusinessCertificationView()
                    .toolbar(.hidden, for: .navigationBar)
                    .environmentObject(router)
                }
              }
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        }
        .navigationDestination(for: CakeShopDestination.self, destination: { destination in
          if case .shopDetail(let shopId) = destination {
            let _ = diContainer.register(CakeShopDetailViewModel.self) { resolver in
              let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
              let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
              let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
              let likeCakeShopUseCase = resolver.resolve(LikeCakeShopUseCase.self)!
              let cakeShopOwnedStateUseCase = resolver.resolve(CakeShopOwnedStateUseCase.self)!
              let myShopIdUseCase = resolver.resolve(MyShopIdUseCase.self)!
              
              return CakeShopDetailViewModel(shopId: shopId,
                                             cakeShopDetailUseCase: cakeShopDetailUseCase,
                                             cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                             cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                             likeCakeShopUseCase: likeCakeShopUseCase,
                                             cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                                             myShopIdUseCase: myShopIdUseCase)
            }.inObjectScope(.transient)
            CakeShopDetailCoordinator()
              .navigationDestination(for: PublicCakeShopDestination.self) { destination in
                if case .businessCertification(targetShopId: let targetShopId) = destination {
                  let _ = diContainer.register(BusinessCertificationViewModel.self) { resolver in
                    let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
                    return BusinessCertificationViewModel(
                      targetShopId: targetShopId,
                      cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
                  }
                  
                  BusinessCertificationView()
                    .toolbar(.hidden, for: .navigationBar)
                    .environmentObject(router)
                }
              }
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        })
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  SearchTabCoordinator()
}
