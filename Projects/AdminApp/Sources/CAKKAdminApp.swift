//
//  CAKKAdminApp.swift
//  CAKK-Admin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Moya
import MoyaUtil

import FeatureUserAdmin
import DomainUser
import NetworkUser

import FeatureCakeShopAdmin
import DomainCakeShop
import NetworkCakeShop

import DomainSearch
import NetworkSearch

import NetworkImage

import Router
import DIContainer

@main
struct CAKKAdminApp: App {
  
  // MARK: - Properties
  
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  init() {
    setupDIContainer()
  }
  
  
  // MARK: - Internal Methods
  
  var body: some Scene {
    WindowGroup {
      AppCoordinator()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func setupDIContainer() {
    diContainer.register(MoyaProvider<UserAPI>.self) { _ in
      #if STUB
      MoyaProvider<UserAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<CakeShopAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<SearchAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(MoyaProvider<ImageUploadAPI>.self) { _ in
      MoyaProvider<ImageUploadAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    diContainer.register(ImageUploadRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<ImageUploadAPI>.self)!
      return ImageUploadRepository(provider: provider)
    }
    
    diContainer.register(SocialLoginRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return SocialLoginRepositoryImpl(provider: provider)
    }
    
    diContainer.register(SocialLoginSignInUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: repository)
    }
    
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: repository)
    }
    
    diContainer.register(AdminLoginViewModel.self) { resolver in
      let socialLoginSignInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let socialLoginSignUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return AdminLoginViewModel(signInUseCase: socialLoginSignInUseCase,
                                 signUpUseCase: socialLoginSignUpUseCase)
    }
    
    diContainer.register(CakeShopRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<CakeShopAPI>.self)!
      return CakeShopRepositoryImpl(provider: provider)
    }
    
    diContainer.register(UploadCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return UploadCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    diContainer.register(SearchCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return SearchCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeShopListViewModel.self) { resolver in
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return CakeShopListViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
    }
    
    diContainer.register(UploadCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return UploadCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(UploadSingleCakeShopViewModel.self) { resolver in
      let uploadCakeShopUseCase = resolver.resolve(UploadCakeShopUseCase.self)!
      return UploadSingleCakeShopViewModel(uploadCakeShopUseCase: uploadCakeShopUseCase)
    }
    
    diContainer.register(UploadMultipleCakeShopViewModel.self) { resolver in
      let uploadCakeShopUseCase = resolver.resolve(UploadCakeShopUseCase.self)!
      return UploadMultipleCakeShopViewModel(uploadCakeShopUseCase: uploadCakeShopUseCase)
    }
    
    diContainer.register(CakeShopDetailRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<CakeShopAPI>.self)!
      return CakeShopDetailRepositoryImpl(provider: provider)
    }
    
    diContainer.register(CakeShopDetailUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopDetailRepository.self)!
      return CakeShopDetailUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeImagesByShopIdUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return CakeImagesByShopIdUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeShopAdditionalInfoUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopDetailRepository.self)!
      return CakeShopAdditionalInfoUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeShopDetailViewModel.self) { resolver in
      let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
      let cakeImagesByShopIdUseCase = resolver.resolve(CakeImagesByShopIdUseCase.self)!
      let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
      
      let viewModel = CakeShopDetailViewModel(
        shopId: 0,
        cakeShopDetailUseCase: cakeShopDetailUseCase,
        cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
        cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
      return viewModel
    }
    
    diContainer.register(EditShopBasicInfoUseCase.self) { resolver in
      let cakeShopRepository = resolver.resolve(CakeShopRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return EditShopBasicInfoUseCaseImpl(cakeShopRepository: cakeShopRepository,
                                          imageUploadRepository: imageUploadRepository)
    }
    
    diContainer.register(EditExternalLinkUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditCakeShopExternalLInkUseCaseImpl(repository: repository)
    }
    
    diContainer.register(EditWorkingDayUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditWorkingDayUseCaseImpl(repository: repository)
    }
    
    diContainer.register(EditShopAddressUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditShopAddressUseCaseImpl(repository: repository)
    }

    
    diContainer.register(UploadCakeImageUseCase.self) { resolver in
      let cakeShopRepository = resolver.resolve(CakeShopRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return UploadCakeImageUseCaseImpl(cakeShopRepository: cakeShopRepository,
                                        imageUploadRepository: imageUploadRepository)
    }
    
    diContainer.register(EditCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditCakeImageUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeImageDetailUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return CakeImageDetailUseCaseImpl(repository: repository)
    }
    
    diContainer.register(DeleteCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return DeleteCakeImageUseCaseImpl(repository: repository)
    }
  }
}
