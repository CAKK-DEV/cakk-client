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
  
  @State private var isShowingSuccessStateView = false
  
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      if viewModel.signUpState == .loading {
        VStack(spacing: 28) {
          ProgressView()
            .controlSize(.regular)
            .tint(Color.white)
          
          Text("계정 생성중...")
            .font(.pretendard(size: 27, weight: .bold))
            .foregroundStyle(Color.white)
            .whiteTextShadow()
        }
      } else {
        ZStack {
          Text("회원가입이 성공적으로 완료되었습니다")
            .multilineTextAlignment(.center)
            .font(.pretendard(size: 27, weight: .bold))
            .foregroundStyle(Color.white)
            .whiteTextShadow()
            .scaleEffect(isShowingSuccessStateView ? 1.0 : 0)
            .opacity(isShowingSuccessStateView ? 1.0 : 0)
            .animation(.smooth, value: isShowingSuccessStateView)
          
          LottieViewRepresentable(lottieFile: .confetti, contentMode: .scaleAspectFill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
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
        DialogManager.shared.showDialog(.serverError(completion: {
          stepRouter.popToRoot()
        }))
        
      case .success:
        withAnimation {
          isShowingSuccessStateView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          stepRouter.pushStep()
        }
        
      default:
        break
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  @StateObject var stepRouter = StepRouter(steps: [])
  @StateObject var viewModel: SocialLoginViewModel
  
  init() {
    let viewModel = SocialLoginViewModel(signInUseCase: MockSocialLoginSignInUseCase(),
                                         signUpUseCase: MockSocialLoginSignUpUseCase())
    _viewModel = .init(wrappedValue: viewModel)
  }

  var body: some View {
    SignUp_Processing()
      .environmentObject(stepRouter)
      .environmentObject(viewModel)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    PreviewContent()
  }
}
