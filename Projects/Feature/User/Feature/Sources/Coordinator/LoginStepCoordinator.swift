//
//  LoginStepCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

import DesignSystem
import Router

import DIContainer

public struct LoginStepCoordinator: View {
  
  // MARK: - Properties
  
  /// login step이 변해도 gradient background는 새로 업데이트 되는것을 막기 위해 State var로 관리
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  @StateObject private var stepRouter: StepRouter
  @StateObject private var socialLoginViewModel: SocialLoginViewModel
  
  
  // MARK: - Initializers
  
  public init(onFinish: @escaping () -> Void) {
    let diContainer = DIContainer.shared.container
    _stepRouter = .init(wrappedValue: StepRouter(steps: [AnyView(Login_Root())], onFinish: onFinish))
    _socialLoginViewModel = .init(wrappedValue: diContainer.resolve(SocialLoginViewModel.self)!)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      gradientBackground
      
      stepRouter.steps[stepRouter.currentStep]
        .environmentObject(stepRouter)
        .environmentObject(socialLoginViewModel)
    }
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(SocialLoginSignInUseCase.self) { _ in
    MockSocialLoginSignInUseCase()
  }
  diContainer.register(SocialLoginSignUpUseCase.self) { _ in
    MockSocialLoginSignUpUseCase()
  }
  diContainer.register(SocialLoginViewModel.self) { resolver in
    let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
    let signUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
    return SocialLoginViewModel(signInUseCase: signInUseCase,
                         signUpUseCase: signUpUseCase)
  }
  
  return LoginStepCoordinator(onFinish: { })
}
