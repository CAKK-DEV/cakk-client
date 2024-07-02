//
//  CakeShopTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureCakeShop
import FeatureCakeShopAdmin
import FeatureSearch

import FeatureCakeShop
import DomainCakeShop

import DomainBusinessOwner
import FeatureUser

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
            
          case .businessCertification(targetShopId: let targetShopId):
            let _ = diContainer.register(BusinessCertificationViewModel.self) { resolver in
              let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
              return BusinessCertificationViewModel(
                targetShopId: targetShopId,
                cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
            }
            
            BusinessCertificationView()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
            
          case .editExternalLink(let shopId, let externalLinks):
            let _ = diContainer.register(EditExternalLinkViewModel.self) { resolver in
              let editExternalLinkUseCase = resolver.resolve(EditExternalLinkUseCase.self)!
              return EditExternalLinkViewModel(shopId: shopId, 
                                               editExternalLinkUseCase: editExternalLinkUseCase,
                                               externalShopLinks: externalLinks)
            }
            EditExternalLinkView()
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
