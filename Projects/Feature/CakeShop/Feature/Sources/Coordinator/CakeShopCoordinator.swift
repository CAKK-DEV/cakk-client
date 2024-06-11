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


enum SheetDestination: Identifiable {
  case quickInfo(shopId: Int, cakeImageUrl: String)
  
  var id: String {
    switch self {
    case .quickInfo:
      return "ImageDetail"
    }
  }
}

enum Destination: Hashable {
  case categoryDetail(initialCategory: CakeCategory)
}

public struct CakeShopCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  public init() { }
  
  // MARK: - Views
  
  public var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopHomeView()
        .sheet(item: $router.presentedSheet) { sheet in
          if let destination = sheet.destination as? SheetDestination {
            switch destination {
            case .quickInfo(let shopId, let cakeImageUrl):
              let _ = diContainer.register(CakeShopQuickInfoViewModel.self) { resolver in
                let useCase = resolver.resolve(CakeShopQuickInfoUseCase.self)!
                return CakeShopQuickInfoViewModel(shopId: shopId,
                                                  cakeImageUrl: cakeImageUrl,
                                                  useCase: useCase)
              }
              CakeShopQuickInfoView()
            }
          }
        }
        .navigationDestination(for: Destination.self) { destination in
          switch destination {
          case .categoryDetail(let initialCategory):
            diContainer.register(CategoryDetailViewModel.self) { resolver in
              let useCase = resolver.resolve(CakeImagesByCategoryUseCase.self)!
              return CategoryDetailViewModel(initialCategory: initialCategory,
                                             useCase: useCase)
            }.inObjectScope(.transient)
            
            return CakeCategoryDetailView()
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        }
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop

struct CakeShopCoordinator_Preview: PreviewProvider {
  struct ContentView: View {
    @StateObject private var router = Router()
    private let diContainer = DIContainer.shared.container
    
    init() {
      diContainer.register(CakeImagesByCategoryUseCase.self) { _ in
        MockCakeImagesByCategoryUseCase()
      }
      diContainer.register(CakeShopQuickInfoUseCase.self) { _ in
        MockCakeShopQuickInfoUseCase()
      }
    }
    
    var body: some View {
      NavigationStack(path: $router.navPath) {
        CakeShopCoordinator()
          .environmentObject(router)
      }
    }
  }
  
  static var previews: some View {
    ContentView()
  }
}
