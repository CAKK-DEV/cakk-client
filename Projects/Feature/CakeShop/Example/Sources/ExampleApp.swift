import SwiftUI

import DomainCakeShop
import NetworkCakeShop
import FeatureCakeShop

import Moya
import MoyaUtil

import Swinject
import Router

@main
struct ExampleApp: App {
  
  // MARK: - Properties
  
  @StateObject var router = Router()
  private var diContainer: Container
  
  
  // MARK: - Initializers
  
  init() {
    diContainer = Container()
    setupDiContainer()
  }
  
  
  // MARK: - Views
  
  var body: some Scene {
    WindowGroup {
      CakeShopCoordinator(diContainer: diContainer)
        .environmentObject(router)
    }
  }
  
  // MARK: - Private Methods
  
  private func setupDiContainer() {
    diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) },
                                plugins: [MoyaLoggingPlugin()])
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
  }
}
