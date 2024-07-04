//
//  UserCoordinator.swift
//  FeatureUser
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Router
import DIContainer


// MARK: - Destinations

enum UserSheetDestination: Identifiable {
  case login
  
  var id: String {
    switch self {
    case .login:
      return "login"
    }
  }
}

enum Destination: Hashable {
  case editProfile(profile: UserProfile)
  case shopRegistration
}


// MARK: - Coordinator

public struct UserCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  

  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    ProfileView()
      .fullScreenCover(item: $router.presentedSheet) { destination in
        if let _ = destination.destination as? UserSheetDestination {
          LoginStepCoordinator(onFinish: {
            router.presentedSheet = nil
          })
        }
      }
      .navigationDestination(for: Destination.self) { destination in
        switch destination {
        case .editProfile(let profile):
          let _ = diContainer.register(EditProfileViewModel.self) { resolver in
            let updateUserProfileUseCase = resolver.resolve(UpdateUserProfileUseCase.self)!
            let withdrawUseCase = resolver.resolve(WithdrawUseCase.self)!
            return EditProfileViewModel(userProfile: profile,
                                        updateUserProfileUseCase: updateUserProfileUseCase,
                                        withdrawUseCase: withdrawUseCase)
          }
          EditProfileView()
            .navigationBarBackButtonHidden()
            .environmentObject(router)
          
        case .shopRegistration:
          ShopRegistrationCoordinator()
            .navigationBarBackButtonHidden()
            .environmentObject(router)
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
    diContainer.register(ProfileViewModel.self) { _ in
      let userProfileUseCase = MockUserProfileUseCase(role: .user)
      return ProfileViewModel(userProfileUseCase: userProfileUseCase)
    }
    
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
    NavigationStack(path: $router.navPath) {
      UserCoordinator()
        .environmentObject(router)
    }
  }
}


// MARK: - Preview

#Preview {
  PreviewContent()
}
