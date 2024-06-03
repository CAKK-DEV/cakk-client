//
//  CakeShopCoordinator.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import DomainCakeShop

import DIContainer

enum Destination: Hashable {
  case categoryDetail(initialCategory: CakeCategory)
}

public struct CakeShopCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer: DIContainerProtocol
  
  
  // MARK: - Initializers
  
  public init(diContainer: DIContainerProtocol) {
    self.diContainer = diContainer
  }
  
  // MARK: - Views
  
  public var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopHomeView()
        .navigationDestination(for: Destination.self) { destination in
          switch destination {
          case .categoryDetail(let initialCategory):
            diContainer.register(CategoryDetailViewModel.self) { resolver in
              CategoryDetailViewModel(initialCategory: initialCategory,
                                      diContainer: diContainer)
            }
            return CakeCategoryDetailView(diContainer: diContainer)
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        }
    }
  }
}


// MARK: - Preview
#if DEBUG
import DomainCakeShop
import NetworkCakeShop
import Moya

struct CakeShopCoordinator_Preview: PreviewProvider {
  struct ContentView: View {
    @StateObject private var router = Router()
    private let diContainer: DIContainerProtocol
    
    init() {
      diContainer = SwinjectDIContainer()
      
      diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
        MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 2) })
      }
      
      diContainer.register(CakeImagesByCategoryRepository.self) { resolver in
        CakeImagesByCategoryRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
      }
      
      diContainer.register(CakeImagesByCategoryUseCase.self) { resolver in
        CakeImagesByCategoryUseCaseImpl(repository: resolver.resolve(CakeImagesByCategoryRepository.self)!)
      }
    }
    
    var body: some View {
      NavigationStack(path: $router.navPath) {
        CakeShopCoordinator(diContainer: diContainer)
          .environmentObject(router)
      }
    }
  }
  
  static var previews: some View {
    ContentView()
  }
}
#endif
