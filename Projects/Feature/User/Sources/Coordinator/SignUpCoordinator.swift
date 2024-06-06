//
//  SignUpCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/8/24.
//

import SwiftUI

import DesignSystem
import Router

public struct SignUpStepCoordinator: View {
  
  // MARK: - Properties
  
  /// login step이 변해도 gradient background는 새로 업데이트 되는것을 막기 위해 State var로 관리
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var parentCoordinator: StepRouter
  @StateObject private var coordinator = StepRouter(steps: [])
  
  
  // MARK: - Initializers
  
  public init(containsEmailInput: Bool = false,
              onFinish: @escaping () -> Void) {
    if containsEmailInput {
      _coordinator = .init(wrappedValue: StepRouter(steps: [
        AnyView(SignUp_Email()),
        AnyView(SignUp_Gender()),
        AnyView(SignUp_Birth()),
        AnyView(SignUp_Processing())
      ], onFinish: onFinish))
    } else {
      _coordinator = .init(wrappedValue: StepRouter(steps: [
        AnyView(SignUp_Gender()),
        AnyView(SignUp_Birth()),
        AnyView(SignUp_Processing())
      ], onFinish: onFinish))
    }
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      gradientBackground
      
      coordinator.steps[coordinator.currentStep]
        .environmentObject(coordinator.withParent(coordinator: parentCoordinator))
    }
    .ignoresSafeArea(.keyboard)
  }
}


// MARK: - Preview

#if DEBUG
import PreviewSupportUser
import DomainUser
import DIContainer

private struct PreviewContent: View {
  @StateObject var parentCoordinator = StepRouter(steps: [])
  @StateObject var viewModel: SocialLoginViewModel
  
  init() {
    let diContainer = SwinjectDIContainer()
    diContainer.register(SocialLoginSignInUseCase.self) { resolver in
      MockSocialLoginSignInUseCase()
    }
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      MockSocialLoginSignUpUseCase()
    }
    _viewModel = .init(wrappedValue: SocialLoginViewModel(diContainer: diContainer))
  }
  
  var body: some View {
    SignUpStepCoordinator(onFinish: { })
      .environmentObject(parentCoordinator)
      .environmentObject(viewModel)
  }
}

#Preview {
  PreviewContent()
}
#endif
