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

public enum LoginPublicDestination: Identifiable {
  case home
  
  public var id: String {
    switch self {
    case .home:
      return "home"
    }
  }
}

public struct LoginStepCoordinator: View {
  
  // MARK: - Properties
  
  private let diContainer: DIContainerProtocol
  
  /// login step이 변해도 gradient background는 새로 업데이트 되는것을 막기 위해 State var로 관리
  @State var gradientBackground = AnimatedGradientBackground(backgroundColor: Color(hex: "FEB0CD"),
                                                             gradientColors: [
                                                              Color(hex: "FE85A5"),
                                                              Color(hex: "FE85A5"),
                                                              Color(hex: "FED6C3")
                                                             ])
  @StateObject private var stepRouter = StepRouter(steps: [
    AnyView(Login_Root())
  ])
  @StateObject private var socialLoginViewModel: SocialLoginViewModel
  
  
  // MARK: - Initializers
  
  public init(diContainer: DIContainerProtocol) {
    self.diContainer = diContainer
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
    .onChange(of: socialLoginViewModel.signInState) { loginState in
      if loginState == .newUser {
        if socialLoginViewModel.loginType == .kakao {
          stepRouter.steps.append(AnyView(SignUpStepCoordinator(containsEmailInput: true)))
        } else {
          stepRouter.steps.append(AnyView(SignUpStepCoordinator(containsEmailInput: false)))
        }
      }
    }
  }
}


// MARK: - Preview

//#Preview {
//  LoginStepCoordinator()
//}
