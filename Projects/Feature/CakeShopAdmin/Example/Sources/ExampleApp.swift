//
//  ExampleApp.swift
//  ExampleBusiness
//
//  Created by 이승기 on 6/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureCakeShopAdmin

import DomainSearch
import NetworkSearch

import DomainUser
import NetworkUser

import Moya
import MoyaUtil

import DIContainer

@main
struct ExampleApp: App {
  
  // MARK: - Properties
  
  @StateObject var router = Router()
  
  
  // MARK: - Initializers
  
  init() {
    setupDIContainer()
  }
  
  
  // MARK: - Views
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navPath) {
        ShopRegistrationCoordinator()
          .environmentObject(router)
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func setupDIContainer() {
    let diContainer = DIContainer.shared.container
    
    diContainer.register(MoyaProvider<UserAPI>.self) { _ in
      #if STUB
      MoyaProvider<UserAPI>(stubClosure: { _ in .delayed(seconds: 1) })
      #else
      MoyaProvider<UserAPI>()
      #endif
    }
    
    diContainer.register(UserProfileRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return UserProfileRepositoryImpl(provider: provider)
    }
    
    diContainer.register(CakeShopOwnerVerificationUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return CakeShopOwnerVerificationUseCaseImpl(repository: repository)
    }
    
    diContainer.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1) })
      #else
      MoyaProvider<SearchAPI>()
      #endif
    }
    
    diContainer.register(SearchRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    diContainer.register(SearchCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return SearchCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchMyShopViewModel.self) { resolver in
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return SearchMyShopViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
    }
  }
}
