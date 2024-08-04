//
//  FeatureBusinessOwnerAssembly.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import DomainBusinessOwner
import NetworkBusinessOwner
import NetworkImage

import FeatureUser
import DomainUser
import DomainCakeShop

final class FeatureBusinessOwnerAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<BusinessOwnerAPI>.self) { _ in
      #if STUB
      MoyaProvider<BusinessOwnerAPI>(stubClosure: { _ in .delayed(seconds: 0.2) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<BusinessOwnerAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    container.register(BusinessOwnerRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<BusinessOwnerAPI>.self)!
      return BusinessOwnerRepositoryImpl(provider: provider)
    }
    
    container.register(CakeShopOwnerVerificationUseCase.self) { resolver in
      let businessOwnerRepository = resolver.resolve(BusinessOwnerRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return CakeShopOwnerVerificationUseCaseImpl(businessOwnerRepository: businessOwnerRepository,
                                                  imageUploadRepository: imageUploadRepository)
    }
    
    container.register(BusinessOwnerProfileViewModel.self) { resolver in
      let myShopIdUseCase = resolver.resolve(MyShopIdUseCase.self)!
      let cakeShopDetailUseCase = resolver.resolve(CakeShopDetailUseCase.self)!
      let cakeShopAdditionalInfoUseCase = resolver.resolve(CakeShopAdditionalInfoUseCase.self)!
      return BusinessOwnerProfileViewModel(myShopIdUseCase: myShopIdUseCase,
                                           cakeShopDetailUseCase: cakeShopDetailUseCase,
                                           cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    }
  }
}
