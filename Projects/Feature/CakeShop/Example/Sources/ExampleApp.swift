import SwiftUI

import DomainCakeShop
import NetworkCakeShop
import FeatureCakeShop

import Moya
import MoyaUtil

import Router

import DIContainer

import PreviewSupportCakeShop

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
      CakeShopCoordinator()
        .environmentObject(router)
    }
  }
  
  // MARK: - Private Methods
  
  private func setupDiContainer() {
    let diContainer = DIContainer.shared.container

    diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<CakeShopAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(CakeImagesByCategoryRepository.self) { resolver in
      CakeImagesByCategoryRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
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
      MockCakeShopDetailUseCase()
    }
    
    diContainer.register(CakeImagesByShopIdUseCase.self) { _ in
      MockCakeImagesByShopIdUseCase()
    }
    
    diContainer.register(CakeShopAdditionalInfoUseCase.self) { _ in
      MockCakeShopAdditionalInfoUseCase()
    }
  }
}
