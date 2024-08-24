//
//  EditProfileRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

import DomainUser

public struct EditProfileRouteBuilder: RouteBuilder {
  public var matchPath: String { "edit_profile" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      let container = DIContainer.shared.container
      container.register(EditProfileViewModel.self) { resolver in
        let updateUserProfileUseCase = resolver.resolve(UpdateUserProfileUseCase.self)!
        let signOutUseCase = resolver.resolve(SocialLoginSignOutUseCase.self)!
        let withdrawUseCase = resolver.resolve(WithdrawUseCase.self)!
        
        let userProfileUseCase = resolver.resolve(UserProfileUseCase.self)!
        
        return .init(userProfileUseCase: userProfileUseCase,
                     updateUserProfileUseCase: updateUserProfileUseCase,
                     signOutUseCase: signOutUseCase,
                     withdrawUseCase: withdrawUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        return EditProfileView()
      }
    }
  }
}

