//
//  FeatureSearchAssembly.swift
//  CAKK
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
import UserDefaultsSearchHistory

final class FeatureSearchAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      return MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1)})
      #else
      return MoyaProvider<SearchAPI>()
      #endif
    }
    
    container.register(SearchRepositoryImpl.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    container.register(TrendingSearchKeywordUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return TrendingSearchKeywordUseCaseImpl(repository: repository)
    }
    
    container.register(SearchCakeImagesUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return SearchCakeImagesUseCaseImpl(repository: repository)
    }
    
    container.register(SearchCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return SearchCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(SearchViewModel.self) { resolver in
      let trendingSearchKeywordUseCase = resolver.resolve(TrendingSearchKeywordUseCase.self)!
      let searchCakeImagesUseCase = resolver.resolve(SearchCakeImagesUseCase.self)!
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                             searchCakeImagesUseCase: searchCakeImagesUseCase,
                             searchCakeShopUseCase: searchCakeShopUseCase)
    }
    
    container.register(SearchHistoryUseCase.self) { _ in
      return UserDefaultsSearchHistoryUseCase()
    }
    
    container.register(SearchHistoryViewModel.self) { resolver in
      let searchHistoryUseCase = resolver.resolve(SearchHistoryUseCase.self)!
      return SearchHistoryViewModel(searchHistoryUseCase: searchHistoryUseCase)
    }
    
    container.register(SearchRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    container.register(TrendingCakeShopsUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return TrendingCakeShopsUseCaseImpl(repository: repository)
    }
    
    container.register(SearchCakeShopOnMapViewModel.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      let searchLocatedCakeShopUseCase = SearchLocatedCakeShopUseCaseImpl(repository: repository)
      return SearchCakeShopOnMapViewModel(useCase: searchLocatedCakeShopUseCase)
    }
    
    container.register(SearchLocatedCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return SearchLocatedCakeShopUseCaseImpl(repository: repository)
    }
    
    container.register(TrendingCakeImagesUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return TrendingCakeImagesUseCaseImpl(repository: repository)
    }
    
    container.register(CakeImagesByCategoryUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return CakeImagesByCategoryUseCaseImpl(repository: repository)
    }
    
    container.register(CakeImagesByShopIdUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return CakeImagesByShopIdUseCaseImpl(repository: repository)
    }
  }
}
