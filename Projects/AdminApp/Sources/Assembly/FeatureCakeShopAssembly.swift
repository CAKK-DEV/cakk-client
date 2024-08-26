//
//  FeatureCakeShopAssembly.swift
//  CAKK-Admin
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import FeatureCakeShopAdmin
import DomainCakeShop
import NetworkCakeShop

import DomainSearch
import NetworkImage

final class FeatureCakeShopAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) })
      #else
      MoyaProvider<CakeShopAPI>()
      #endif
    }
    
    container.register(CakeShopRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<CakeShopAPI>.self)!
      return CakeShopRepositoryImpl(provider: provider)
    }
    
    container.register(UploadCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return UploadCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(UploadCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return UploadCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(UploadSingleCakeShopViewModel.self) { resolver in
      let uploadCakeShopUseCase = resolver.resolve(UploadCakeShopUseCase.self)!
      return UploadSingleCakeShopViewModel(uploadCakeShopUseCase: uploadCakeShopUseCase)
    }
    
    container.register(UploadMultipleCakeShopViewModel.self) { resolver in
      let uploadCakeShopUseCase = resolver.resolve(UploadCakeShopUseCase.self)!
      return UploadMultipleCakeShopViewModel(uploadCakeShopUseCase: uploadCakeShopUseCase)
    }
    
    container.register(CakeShopDetailRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<CakeShopAPI>.self)!
      return CakeShopDetailRepositoryImpl(provider: provider)
    }
    
    container.register(CakeShopDetailUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopDetailRepository.self)!
      return CakeShopDetailUseCaseImpl(repository: repository)
    }
    
    container.register(CakeShopAdditionalInfoUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopDetailRepository.self)!
      return CakeShopAdditionalInfoUseCaseImpl(repository: repository)
    }
    
    container.register(CakeShopDetailViewModel.self) { resolver in
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
    
    container.register(EditShopBasicInfoUseCase.self) { resolver in
      let cakeShopRepository = resolver.resolve(CakeShopRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return EditShopBasicInfoUseCaseImpl(cakeShopRepository: cakeShopRepository,
                                          imageUploadRepository: imageUploadRepository)
    }
    
    container.register(EditExternalLinkUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditCakeShopExternalLInkUseCaseImpl(repository: repository)
    }
    
    container.register(EditWorkingDayUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditWorkingDayUseCaseImpl(repository: repository)
    }
    
    container.register(EditShopAddressUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditShopAddressUseCaseImpl(repository: repository)
    }

    
    container.register(UploadCakeImageUseCase.self) { resolver in
      let cakeShopRepository = resolver.resolve(CakeShopRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return UploadCakeImageUseCaseImpl(cakeShopRepository: cakeShopRepository,
                                        imageUploadRepository: imageUploadRepository)
    }
    
    container.register(EditCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return EditCakeImageUseCaseImpl(repository: repository)
    }
    
    container.register(CakeImageDetailUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return CakeImageDetailUseCaseImpl(repository: repository)
    }
    
    container.register(DeleteCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(CakeShopRepository.self)!
      return DeleteCakeImageUseCaseImpl(repository: repository)
    }
    
    container.register(CakeShopListViewModel.self) { resolver in
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return CakeShopListViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
    }
  }
}
