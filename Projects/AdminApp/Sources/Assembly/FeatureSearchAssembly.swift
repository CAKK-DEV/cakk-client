//
//  FeatureSearchAssembly.swift
//  CAKK-Admin
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import FeatureSearch
import DomainSearch
import NetworkSearch

final class FeatureSearchAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<SearchAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    container.register(SearchRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    container.register(SearchCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return SearchCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(CakeImagesByShopIdUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return CakeImagesByShopIdUseCaseImpl(repository: repository)
    }
  }
}
