//
//  ExampleApp.swift
//  ExampleSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainSearch
import NetworkSearch
import FeatureSearch
import UserDefaultsSearchHistory

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
    setupDiContainer()
  }
  
  
  // MARK: - Views
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navPath) {
        SearchCoordinator()
          .environmentObject(router)
      }
    }
  }
  
  // MARK: - Private Methods
  
  private func setupDiContainer() {
    let diContainer = DIContainer.shared.container
    
    diContainer.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      return MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1)}, plugins: [MoyaLoggingPlugin()])
      #else
      return MoyaProvider<SearchAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(SearchRepositoryImpl.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    diContainer.register(TrendingSearchKeywordUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return TrendingSearchKeywordUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchCakeImagesUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return SearchCakeImagesUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchViewModel.self) { resolver in
      let trendingSearchKeywordUseCase = resolver.resolve(TrendingSearchKeywordUseCase.self)!
      let searchCakeImagesUseCase = resolver.resolve(SearchCakeImagesUseCase.self)!
      return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                             searchCakeImagesUseCase: searchCakeImagesUseCase)
    }
    
    diContainer.register(SearchHistoryUseCase.self) { _ in
      return UserDefaultsSearchHistoryUseCase()
    }
    
    diContainer.register(SearchHistoryViewModel.self) { resolver in
      let searchHistoryUseCase = resolver.resolve(SearchHistoryUseCase.self)!
      return SearchHistoryViewModel(searchHistoryUseCase: searchHistoryUseCase)
    }
  }
}
