//
//  CakeShopDetailCoordinator.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainCakeShop

import DIContainer
import Router

enum CakeShopDetailDestination: Hashable {
  case editBasicInfo(cakeShopDetail: CakeShopDetail)
  case editExternalLink(shopId: Int, externalLinks: [ExternalShopLink])
  case editWorkingDay(shopId: Int, workingDaysWithTime: [WorkingDayWithTime])
  case editAddress(shopId: Int, cakeShopLocation: CakeShopLocation)
  case editCakeImages(shopId: Int)
  case newCakeImage(shopId: Int)
  case editCakeImageDetail(imageId: Int)
}

public struct CakeShopDetailCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject var router = Router()
  private let diContainer = DIContainer.shared.container
  private let shopId: Int
  
  
  // MARK: - Initializers
  
  public init(shopId: Int) {
    self.shopId = shopId
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopDetailView(shopId: shopId)
        .navigationDestination(for: CakeShopDetailDestination.self) { destination in
          switch destination {
          case .editBasicInfo(let cakeShopDetail):
            let _ = diContainer.register(EditCakeShopBasicInfoViewModel.self) { resolver in
              let editShopBasicInfoUseCase = resolver.resolve(EditShopBasicInfoUseCase.self)!
              return EditCakeShopBasicInfoViewModel(shopDetail: cakeShopDetail, editShopBasicInfoUseCase: editShopBasicInfoUseCase)
            }
            EditCakeShopBasicInfoView()
            
          case .editExternalLink(let shopId, let externalLinks):
            let _ = diContainer.register(EditExternalLinkViewModel.self) { resolver in
              let editExternalLinkUseCase = resolver.resolve(EditExternalLinkUseCase.self)!
              return EditExternalLinkViewModel(shopId: shopId, editExternalLinkUseCase: editExternalLinkUseCase, externalShopLinks: externalLinks)
            }
            EditExternalLinkView()
            
          case .editWorkingDay(let shopId, let workingDaysWithTime):
            let _ = diContainer.register(EditWorkingDayViewModel.self) { resolver in
              let editWorkingDayUseCase = resolver.resolve(EditWorkingDayUseCase.self)!
              return EditWorkingDayViewModel(shopId: shopId, editWorkingDayUseCase: editWorkingDayUseCase, workingDaysWithTime: workingDaysWithTime)
            }
            EditWorkingDayView()
            
          case .editAddress(let shopId, let cakeShopLocation):
            let _ = diContainer.register(EditCakeShopAddressViewModel.self) { resolver in
              let editShopAddressUseCase = resolver.resolve(EditShopAddressUseCase.self)!
              return EditCakeShopAddressViewModel(shopId: shopId, cakeShopLocation: cakeShopLocation, editShopAddressUseCase: editShopAddressUseCase)
            }
            EditCakeShopAddressView()
            
          case .editCakeImages(let shopId):
            let _ = diContainer.register(EditCakeShopImagesViewModel.self) { resolver in
              let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
              return EditCakeShopImagesViewModel(shopId: shopId, cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase)
            }
            EditCakeShopImagesView()
            
          case .newCakeImage(let shopId):
            let _ = diContainer.register(NewCakeImageViewModel.self) { resolver in
              let uploadCakeImageUseCase = resolver.resolve(UploadCakeImageUseCase.self)!
              return NewCakeImageViewModel(shopId: shopId, uploadCakeImageUseCase: uploadCakeImageUseCase)
            }
            NewCakeImageView()
            
          case .editCakeImageDetail(let imageId):
            let _ = diContainer.register(EditCakeImageDetailViewModel.self) { resolver in
              let cakeImageDetailUseCase = resolver.resolve(CakeImageDetailUseCase.self)!
              let editCakeImageUseCase = resolver.resolve(EditCakeImageUseCase.self)!
              let deleteCakeImageUseCase = resolver.resolve(DeleteCakeImageUseCase.self)!
              return EditCakeImageDetailViewModel(cakeImageId: imageId,
                                            cakeImageDetailUseCase: cakeImageDetailUseCase,
                                            editCakeImageUseCase: editCakeImageUseCase,
                                            deleteCakeImageUseCase: deleteCakeImageUseCase)
            }
            EditCakeImageDetailView()
          }
        }
    }
    .environmentObject(router)
    .toolbar(.hidden, for: .navigationBar)
  }
}


// MARK: - Preview

#Preview {
  CakeShopDetailCoordinator(shopId: 0)
}
