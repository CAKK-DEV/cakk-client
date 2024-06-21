//
//  LikeCoordinator.swift
//  FeatureUser
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Router
import DIContainer

public struct LikeCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    LikedItemsView()
      .fullScreenCover(item: $router.presentedSheet) { destination in
        if let _ = destination.destination as? SheetDestination {
          LoginStepCoordinator(onFinish: {
            router.presentedSheet = nil
          })
        }
      }
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  init() {
    diContainer.register(SocialLoginSignInUseCase.self) { resolver in
      MockSocialLoginSignInUseCase()
    }
    
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      MockSocialLoginSignUpUseCase()
    }
    
    diContainer.register(SocialLoginViewModel.self) { resolver in
      let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let signUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return SocialLoginViewModel(signInUseCase: signInUseCase,
                                  signUpUseCase: signUpUseCase)
    }
    
    diContainer.register(LikedItemsViewModel.self) { _ in
      let likeCakeImageUseCase = MockLikeCakeImageUseCase()
      let likeCakeShopUseCase = MockLikeCakeShopUseCase()
      return LikedItemsViewModel(likeCakeImageUseCase: likeCakeImageUseCase,
                                 likeCakeShopUseCase: likeCakeShopUseCase)
    }
  }
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      LikeCoordinator()
        .environmentObject(router)
    }
  }
}

#Preview {
  PreviewContent()
}
