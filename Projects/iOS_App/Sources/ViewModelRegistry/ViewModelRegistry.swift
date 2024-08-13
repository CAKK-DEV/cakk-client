//
//  ViewModelRegistry.swift
//  CAKK
//
//  Created by 이승기 on 7/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import DIContainer

import FeatureCakeShop
import FeatureUser
import FeatureCakeShopAdmin
import FeatureSearch

import CommonDomain
import DomainCakeShop
import DomainSearch
import DomainUser
import DomainBusinessOwner

struct ViewModelRegistry {
  
  // MARK: - Properties
  
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Public Methods
  
  func registerCakeShopDetailViewModel(shopId: Int) {
    diContainer.register(CakeShopDetailViewModel.self) { resolver in
      let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
      let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
      let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
      let likeCakeShopUseCase = resolver.resolve(LikeCakeShopUseCase.self)!
      let cakeShopOwnedStateUseCase = resolver.resolve(CakeShopOwnedStateUseCase.self)!
      let myShopIdUseCase = resolver.resolve(MyShopIdUseCase.self)!
      
      return CakeShopDetailViewModel(
        shopId: shopId,
        cakeShopDetailUseCase: cakeShopDetailUseCase,
        cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
        cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
        likeCakeShopUseCase: likeCakeShopUseCase,
        cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
        myShopIdUseCase: myShopIdUseCase
      )
    }
  }
  
  func registerCakeShopQuickInfoViewModel(imageId: Int, cakeImageUrl: String, shopId: Int) {
    diContainer.register(CakeShopQuickInfoViewModel.self) { resolver in
      let cakeQuickInfoUseCase = resolver.resolve(CakeShopQuickInfoUseCase.self)!
      let likeCakeImageUseCase = resolver.resolve(LikeCakeImageUseCase.self)!
      return CakeShopQuickInfoViewModel(imageId: imageId,
                                        cakeImageUrl: cakeImageUrl,
                                        shopId: shopId,
                                        cakeQuickInfoUseCase: cakeQuickInfoUseCase,
                                        likeCakeImageUseCase: likeCakeImageUseCase)
    }
  }
  
  func registerBusinessCertificationViewModel(shopId: Int) {
    diContainer.register(BusinessCertificationViewModel.self) { resolver in
      let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
      return BusinessCertificationViewModel(
        targetShopId: shopId,
        cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
    }
  }
  
  func registerSocialLoginViewModel() {
    diContainer.register(SocialLoginViewModel.self) { resolver in
      let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let singUPUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return SocialLoginViewModel(signInUseCase: signInUseCase,
                                  signUpUseCase: singUPUseCase)
    }
  }
  
  func registerEmailVerificationViewModel() {
    diContainer.register(EmailVerificationViewModel.self) { resolver in
      let sendVerificationCodeUseCase = resolver.resolve(SendVerificationCodeUseCase.self)!
      let confirmVerificationCodeUseCase = resolver.resolve(ConfirmVerificationCodeUseCase.self)!
      return EmailVerificationViewModel(sendVerificationCodeUseCase: sendVerificationCodeUseCase,
                                        confirmVerificationCodeUseCase: confirmVerificationCodeUseCase)
    }
  }
  
  func registerEditExternalLinkViewModel(shopId: Int, externalLinks: [ExternalShopLink]) {
    diContainer.register(EditExternalLinkViewModel.self) { resolver in
      let editExternalLinkUseCase = resolver.resolve(EditExternalLinkUseCase.self)!
      return EditExternalLinkViewModel(shopId: shopId,
                                       editExternalLinkUseCase: editExternalLinkUseCase,
                                       externalShopLinks: externalLinks)
    }
  }
  
  func registerEditWorkingDayViewModel(shopId: Int, workingDaysWithTime: [WorkingDayWithTime]) {
    diContainer.register(EditWorkingDayViewModel.self) { resolver in
      let editWorkingDayUseCase = resolver.resolve(EditWorkingDayUseCase.self)!
      return EditWorkingDayViewModel(shopId: shopId,
                                     editWorkingDayUseCase: editWorkingDayUseCase,
                                     workingDaysWithTime: workingDaysWithTime)
    }
  }
  
  func registerEditCakeShopBasicInfoViewModel(shopDetail: CakeShopDetail) {
    diContainer.register(EditCakeShopBasicInfoViewModel.self) { resolver in
      let editShopBasicInfoUseCase = resolver.resolve(EditShopBasicInfoUseCase.self)!
      return EditCakeShopBasicInfoViewModel(shopDetail: shopDetail, editShopBasicInfoUseCase: editShopBasicInfoUseCase)
    }
  }
  
  func registerEditCakeShopAddressViewModel(shopId: Int, cakeShopLocation: CakeShopLocation) {
    diContainer.register(EditCakeShopAddressViewModel.self) { resolver in
      let editShopAddressUseCase = resolver.resolve(EditShopAddressUseCase.self)!
      return EditCakeShopAddressViewModel(shopId: shopId,
                                          cakeShopLocation: cakeShopLocation,
                                          editShopAddressUseCase: editShopAddressUseCase)
    }
  }
  
  func registerEditCakeShopImagesViewModel(shopId: Int) {
    diContainer.register(EditCakeShopImagesViewModel.self) { resolver in
      let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
      return EditCakeShopImagesViewModel(shopId: shopId,
                                         cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase)
    }
  }
}
