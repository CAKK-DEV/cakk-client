//
//  ShopRegistrationCoordinator.swift
//  FeatureBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainUser

import DIContainer
import Router

// MARK: - Destinations

public enum ShopRegistrationDestination: Hashable {
  case businessCertification(targetShopId: Int)
}


// MARK: - Coordinator

public struct ShopRegistrationCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    SearchMyShopView()
      .navigationDestination(for: ShopRegistrationDestination.self) { destination in
        switch destination {
        case .businessCertification(let targetShopId):
          let _ = diContainer.register(BusinessCertificationViewModel.self) { resolver in
            let cakeShopOwnerVerificationUseCase = resolver.resolve(CakeShopOwnerVerificationUseCase.self)!
            return BusinessCertificationViewModel(
              targetShopId: targetShopId,
              cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
          }
          
          BusinessCertificationView()
            .toolbar(.hidden, for: .navigationBar)
            .environmentObject(router)
        }
      }
  }
}


// MARK: - Preview

import PreviewSupportUser
import PreviewSupportSearch

private struct PreviewContent: View {
  
  @StateObject var router = Router()
  
  init() {
    let diContainer = DIContainer.shared.container
    
    diContainer.register(SearchMyShopViewModel.self) { resolver in
      let searchCakeShopUseCase = MockSearchCakeShopUseCase()
      return SearchMyShopViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
    }
    
    diContainer.register(CakeShopOwnerVerificationUseCase.self) { _ in
      return MockCakeShopOwnerVerificationUseCase()
    }
  }
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      ShopRegistrationCoordinator()
    }
    .environmentObject(router)
  }
}

#Preview {
  PreviewContent()
}
