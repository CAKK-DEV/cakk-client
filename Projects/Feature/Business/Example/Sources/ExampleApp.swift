//
//  ExampleApp.swift
//  ExampleBusiness
//
//  Created by 이승기 on 6/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainBusiness
import FeatureBusiness
import NetworkBusiness

import DomainSearch
import NetworkSearch

import Moya
import MoyaUtil

import Router
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
    
    diContainer.register(MoyaProvider<BusinessAPI>.self) { _ in
      #if STUB
      MoyaProvider<BusinessAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<BusinessAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(BusinessRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<BusinessAPI>.self)!
      return BusinessRepositoryImpl(provider: provider)
    }
    
    diContainer.register(UploadCertificationUseCase.self) { resolver in
      let repository = resolver.resolve(BusinessRepository.self)!
      return UploadCertificationUseCaseImpl(repository: repository)
    }
    
    diContainer.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<SearchAPI>(plugins: [MoyaLoggingPlugin()])
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
