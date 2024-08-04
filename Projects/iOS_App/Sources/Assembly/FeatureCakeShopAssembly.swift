//
//  CakeShopFeatureAssembly.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import FeatureCakeShop
import DomainCakeShop
import DomainSearch
import NetworkCakeShop
import NetworkImage

final class FeatureCakeShopAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<CakeShopAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    container.register(CakeShopDetailRepository.self) { resolver in
      CakeShopDetailRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    container.register(CakeShopQuickInfoRepository.self) { resolver in
      CakeShopQuickInfoRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    container.register(CakeShopQuickInfoUseCase.self) { resolver in
      CakeShopQuickInfoUseCaseImpl(repository: resolver.resolve(CakeShopQuickInfoRepository.self)!)
    }
    
    container.register(CakeShopDetailUseCase.self) { resolver in
      CakeShopDetailUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    container.register(CakeShopAdditionalInfoUseCase.self) { resolver in
      CakeShopAdditionalInfoUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    container.register(CakeShopOwnedStateUseCase.self) { resolver in
      let provider = resolver.resolve(CakeShopDetailRepository.self)!
      return CakeShopOwnedStateUseCaseImpl(repository: provider)
    }
    
    container.register(TrendingCakeShopViewModel.self) { resolver in
      TrendingCakeShopViewModel(useCase: resolver.resolve(TrendingCakeShopsUseCase.self)!)
    }
    
    container.register(CakeShopNearByMeViewModel.self) { resolver in
      CakeShopNearByMeViewModel(useCase: resolver.resolve(SearchLocatedCakeShopUseCase.self)!)
    }
    
    container.register(TrendingCakeImagesViewModel.self) { resolver in
      TrendingCakeImagesViewModel(useCase: resolver.resolve(TrendingCakeImagesUseCase.self)!)
    }
    
    
    container.register(CakeShopRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<CakeShopAPI>.self)!
      return CakeShopRepositoryImpl(provider: provider)
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
  }
}
