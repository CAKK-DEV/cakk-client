//
//  UserCoordinator.swift
//  FeatureUser
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Router
import Swinject

enum Destination {
  case editProfile
}

enum SheetDestination: Identifiable {
  case login
  
  var id: String {
    switch self {
    case .login:
      return "login"
    }
  }
}

public struct UserCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer: Container
  

  // MARK: - Initializers
  
  public init(diContainer: Container) {
    self.diContainer = diContainer
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    NavigationStack(path: $router.navPath) {
      ProfileView(diContainer: diContainer)
        .fullScreenCover(item: $router.presentedSheet) { destination in
          if let _ = destination.destination as? SheetDestination {
            LoginStepCoordinator(diContainer: diContainer, onFinish: {
              router.presentedSheet = nil
            })
          }
        }
        .navigationDestination(for: Destination.self) { destination in
          switch destination {
          case .editProfile:
            EditProfileView(diContainer: diContainer)
              .navigationBarBackButtonHidden()
          }
        }
    }
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  
  @StateObject private var router = Router()
  let diContainer: Container
  
  init() {
    diContainer = Container()
    
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
  }
  
  var body: some View {
    UserCoordinator(diContainer: diContainer)
      .environmentObject(router)
  }
}

#Preview {
  PreviewContent()
}
