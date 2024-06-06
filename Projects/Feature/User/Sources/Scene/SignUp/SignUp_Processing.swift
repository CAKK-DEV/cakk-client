//
//  SignUp_Processing.swift
//  FeatureUser
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import Router

struct SignUp_Processing: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var viewModel: SocialLoginViewModel
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 28) {
      ProgressView()
        .controlSize(.regular)
        .tint(Color.white)
      
      Text("게정 생성중...")
        .font(.pretendard(size: 27, weight: .bold))
        .foregroundStyle(Color.white)
        .whiteTextShadow()
    }
    .padding(.bottom, 48)
    .onAppear {
      viewModel.signUp()
    }
    .onChange(of: viewModel.signUpState) { state in
      switch state {
      case .failure:
        DialogManager.shared.showDialog(
          title: "회원가입 실패",
          message: "회원가입에 실패하였어요.\n다시 시도해주세요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .custom({
            stepRouter.popToRoot()
          }))
      case .serverError:
        DialogManager.shared.showDialog(
          title: "서버 에러",
          message: "서버에러가 발생했어요.\n나중에 다시 시도해주세요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .custom({
            stepRouter.popToRoot()
          }))
      case .success:
        print("signed in")
        stepRouter.pushStep()
      default:
        break
      }
    }
  }
}


// MARK: - Preview

#if DEBUG
import PreviewSupportUser
import DomainUser
import DIContainer

private struct PreviewContent: View {
  @StateObject var stepRouter = StepRouter(steps: [])
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
    SignUp_Processing()
      .environmentObject(stepRouter)
      .environmentObject(viewModel)
  }
}

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    PreviewContent()
  }
}
#endif
