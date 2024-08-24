//
//  SignUpRouteBuilder.swift
//  FeatureUser
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import LinkNavigator
import DIContainer

import DomainUser

public struct SignUpRouteBuilder: RouteBuilder {
  public var matchPath: String { "sign_up" }
  
  public init() { }
  
  public var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      guard let loginTypeRawValueString = items["loginType"],
            let loginTypeRawValue = Int(loginTypeRawValueString),
            let loginType = LoginProvider(rawValue: loginTypeRawValue) else {
        return nil
      }
      
      let container = DIContainer.shared.container
      
      guard let userData = container.resolve(UserData.self),
            let credentialData = container.resolve(CredentialData.self) else {
        return nil
      }
      
      container.register(SocialLoginSignUpViewModel.self) { resolver in
        let signUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
        return .init(loginType: loginType,
                     userData: userData,
                     credentialData: credentialData,
                     signUpUseCase: signUpUseCase)
      }
      
      container.register(LinkNavigatorType.self) { _ in
        return navigator
      }
      
      return WrappingController(matchPath: matchPath) {
        SignUpStepCoordinator(
          containsEmailInput: loginType == .kakao,
          onFinish: {
          if navigator.rootCurrentPaths.contains("tab_root") {
            navigator.backToLast(path: "login", isAnimated: false)
            navigator.back(isAnimated: true)
          } else {
            navigator.replace(paths: ["tab_root"], items: [:], isAnimated: true)
          }
        })
      }
    }
  }
}

