import SwiftUI

import DomainCakeShop
import NetworkCakeShop
import FeatureCakeShop

import Moya
import MoyaUtil

import DIContainer
import Router

@main
struct ExampleApp: App {
  
  // MARK: - Properties
  
  @StateObject var router = Router()
  private var diContainer: DIContainerProtocol
  
  
  // MARK: - Initializers
  
  init() {
    diContainer = SwinjectDIContainer()
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
    
    diContainer.register(CakeImagesByCategoryUseCase.self) { resolver in
      CakeImagesByCategoryUseCaseImpl(repository: resolver.resolve(CakeImagesByCategoryRepository.self)!)
    }
  }
}
