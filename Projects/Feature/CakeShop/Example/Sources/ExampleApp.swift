import SwiftUI

import DomainCakeShop
import NetworkCakeShop

import DomainUser
import NetworkUser

import DomainSearch

import FeatureCakeShop

import Moya

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
        CakeShopCoordinator()
          .environmentObject(router)
      }
    }
  }
  
  // MARK: - Private Methods
  
  private func setupDiContainer() {
    let diContainer = DIContainer.shared.container

    diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) })
      #else
      MoyaProvider<CakeShopAPI>()
      #endif
    }
    
    diContainer.register(CakeImagesByCategoryRepository.self) { resolver in
      CakeImagesByCategoryRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeShopDetailRepository.self) { resolver in
      CakeShopDetailRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeShopQuickInfoRepository.self) { resolver in
      CakeShopQuickInfoRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeImagesByCategoryUseCase.self) { resolver in
      CakeImagesByCategoryUseCaseImpl(repository: resolver.resolve(CakeImagesByCategoryRepository.self)!)
    }
    
    diContainer.register(CakeShopQuickInfoUseCase.self) { resolver in
      CakeShopQuickInfoUseCaseImpl(repository: resolver.resolve(CakeShopQuickInfoRepository.self)!)
    }
    
    diContainer.register(CakeShopDetailUseCase.self) { resolver in
      CakeShopDetailUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    diContainer.register(CakeImagesByShopIdUseCase.self) { resolver in
      CakeImagesByShopIdUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    diContainer.register(CakeShopAdditionalInfoUseCase.self) { resolver in
      CakeShopAdditionalInfoUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    diContainer.register(TrendingCakeShopsUseCase.self) { resolver in
      MockTrendingCakeShopsUseCase() // TODO: 네트워킹 구현체로 변경
    }
    
    diContainer.register(TrendingCakeShopViewModel.self) { resolver in
      TrendingCakeShopViewModel(useCase: resolver.resolve(TrendingCakeShopsUseCase.self)!)
    }
    
    diContainer.register(SearchLocatedCakeShopUseCase.self) { resolver in
      MockSearchLocatedCakeShopUseCase() // TODO: 네트워킹 구현체로 변경
    }
    
    diContainer.register(CakeShopNearByMeViewModel.self) { resolver in
      CakeShopNearByMeViewModel(useCase: resolver.resolve(SearchLocatedCakeShopUseCase.self)!)
    }
    
    diContainer.register(TrendingCakeImagesUseCase.self) { resolver in
      MockTrendingCakeImagesUseCase() // TODO: 네트워킹 구현체로 변경
    }
    
    diContainer.register(TrendingCakeImagesViewModel.self) { resolver in
      TrendingCakeImagesViewModel(useCase: resolver.resolve(TrendingCakeImagesUseCase.self)!)
    }
    
    
    // MARK: - Like
    
    diContainer.register(MoyaProvider<LikeAPI>.self) { _ in
      #if STUB
      MoyaProvider<LikeAPI>(stubClosure: { _ in .delayed(seconds: 0.2) })
      #else
      MoyaProvider<LikeAPI>()
      #endif
    }
    
    diContainer.register(LikeRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<LikeAPI>.self)!
      return LikeRepositoryImpl(provider: provider)
    }
    
    diContainer.register(LikeCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(LikeCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeImageUseCaseImpl(repository: repository)
    }
  }
}

import PreviewSupportCakeShop // TODO: Networking 구현 완료되면 삭제할 것
import PreviewSupportSearch
