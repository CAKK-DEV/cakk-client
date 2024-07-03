//
//  ProfileTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import DomainBusinessOwner
import DomainCakeShop

import FeatureUser
import FeatureCakeShopAdmin

import DIContainer

struct ProfileTabCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Views
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      let _ = Self._printChanges()
      UserCoordinator()
        .navigationDestination(for: PublicUserDestination.self) { destination in
          switch destination {
          case .editCakeImages(let shopId):
            let _ = diContainer.register(EditCakeShopImagesViewModel.self) { resolver in
              let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
              return EditCakeShopImagesViewModel(shopId: shopId,
                                                 cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase)
            }
            EditCakeImagesCoordinator()
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
            
          case .editLocation(let shopId, let cakeShopLocation):
            let _ = diContainer.register(EditCakeShopAddressViewModel.self) { resolver in
              let editShopAddressUseCase = resolver.resolve(EditShopAddressUseCase.self)!
              return EditCakeShopAddressViewModel(shopId: shopId,
                                                  cakeShopLocation: cakeShopLocation,
                                                  editShopAddressUseCase: editShopAddressUseCase)
            }
            EditCakeShopAddressView()
              .environmentObject(router)
            
          case .editShopBasicInfo(let shopDetail):
            let _ = diContainer.register(EditCakeShopBasicInfoViewModel.self) { resolver in
              let editShopBasicInfoUseCase = resolver.resolve(EditShopBasicInfoUseCase.self)!
              return EditCakeShopBasicInfoViewModel(shopDetail: shopDetail, editShopBasicInfoUseCase: editShopBasicInfoUseCase)
            }
            EditCakeShopBasicInfoView()
              .environmentObject(router)
            
          case .editWorkingDay(let shopId, let workingDaysWithTime):
            let _ = diContainer.register(EditWorkingDayViewModel.self) { resolver in
              let editWorkingDayUseCase = resolver.resolve(EditWorkingDayUseCase.self)!
              return EditWorkingDayViewModel(shopId: shopId,
                                             editWorkingDayUseCase: editWorkingDayUseCase,
                                             workingDaysWithTime: workingDaysWithTime)
            }
            EditWorkingDayView()
              .environmentObject(router)
            
          default:
            EmptyView()
          }
        }
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  ProfileTabCoordinator()
}
