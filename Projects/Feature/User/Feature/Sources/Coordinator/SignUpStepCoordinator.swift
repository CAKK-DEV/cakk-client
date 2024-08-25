//
//  SignUpStepCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/8/24.
//

import SwiftUI
import CommonUtil
import DesignSystem

import DIContainer

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
  
  @StateObject private var coordinator = StepRouter(steps: [])
  @StateObject private var signUpViewModel: SocialLoginSignUpViewModel
  
  
  // MARK: - Initializers
  
  public init(
    containsEmailInput: Bool,
    onFinish: @escaping () -> Void
  ) {
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
    
    let container = DIContainer.shared.container
    _signUpViewModel = .init(wrappedValue: container.resolve(SocialLoginSignUpViewModel.self)!)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      gradientBackground
      
      coordinator.steps[coordinator.currentStep]
        .environmentObject(coordinator)
        .environmentObject(signUpViewModel)
    }
    .ignoresSafeArea(.keyboard)
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  @StateObject var parentCoordinator = StepRouter(steps: [])
  @StateObject var viewModel: SocialLoginSignUpViewModel
  
  init() {
    let viewModel = SocialLoginSignUpViewModel(
      loginType: .kakao,
      userData: UserData(nickname: "", email: "", birthday: .now, gender: .unknown),
      credentialData: .init(loginProvider: .kakao, idToken: ""),
      signUpUseCase: MockSocialLoginSignUpUseCase()
    )
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    SignUpStepCoordinator(
      containsEmailInput: true,
      onFinish: { }
    )
    .environmentObject(parentCoordinator)
    .environmentObject(viewModel)
  }
}


// MARK: - Preview

#Preview {
  PreviewContent()
}
