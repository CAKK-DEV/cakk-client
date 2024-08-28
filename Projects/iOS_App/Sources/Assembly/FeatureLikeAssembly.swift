//
//  LikeFeatureAssembly.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya

import FeatureUser
import DomainUser
import NetworkUser

final class FeatureLikeAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<LikeAPI>.self) { _ in
      #if STUB
      MoyaProvider<LikeAPI>(stubClosure: { _ in .delayed(seconds: 0.2) })
      #else
      MoyaProvider<LikeAPI>()
      #endif
    }
    
    container.register(LikeRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<LikeAPI>.self)!
      return LikeRepositoryImpl(provider: provider)
    }
    
    container.register(LikeCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(LikeCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeImageUseCaseImpl(repository: repository)
    }
    
    container.register(LikedItemsViewModel.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      let likeCakeImageUseCase = LikeCakeImageUseCaseImpl(repository: repository)
      let likeCakeShopUseCase = LikeCakeShopUseCaseImpl(repository: repository)
      return LikedItemsViewModel(likeCakeImageUseCase: likeCakeImageUseCase,
                                 likeCakeShopUseCase: likeCakeShopUseCase)
    }
  }
}
