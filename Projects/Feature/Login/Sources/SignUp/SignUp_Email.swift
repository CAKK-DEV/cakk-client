//
//  SignUp_Email.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

import DesignSystem
import Router

struct SignUp_Email: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var viewModel: SocialLoginViewModel
  @State private var isShowing = false
  @State private var isDisappearing = false
  
  
  // MARK: - Initializers
  
  init() { }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 44) {
        VStack(spacing: 8) {
          Text("이메일을 입력해 주세요")
            .font(.pretendard(size: 27, weight: .bold))
            .foregroundStyle(Color.white)
            .whiteTextShadow()
            .multilineTextAlignment(.center)
            // isShowing animation
            .offset(x: 0, y: isShowing ? 0 : 120)
            .scaleEffect(isShowing ? 1.0 : 0.95)
            .opacity(isShowing ? 1.0 : 0)
            .blur(radius: isShowing ? 0 : 10)
            // isDisappearing animation
            .offset(y: isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)
          
          if !viewModel.isEmailValid && !viewModel.isEmailEmpty {
            Text("이메일 형식이 올바르지 않아요")
              .font(.pretendard(size: 15, weight: .medium))
              .foregroundStyle(DesignSystemAsset.brandcolor2.swiftUIColor)
          }
        }
        .animation(.easeInOut, value: (!viewModel.isEmailValid && !viewModel.isEmailEmpty))
        
        TextField("email", text: $viewModel.userData.email)
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundStyle(Color.white)
          .padding(.horizontal, 20)
          .frame(width: 312, height: 56)
          .background {
            RoundedRectangle(cornerRadius: 20)
              .stroke(Color.white.opacity(0.3), lineWidth: 3)
          }
          // isShowing animation
          .scaleEffect(isShowing ? 1.0 : 0.95)
          .opacity(isShowing ? 1.0 : 0)
          // isDisappearing animation
          .offset(y: isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
          .scaleEffect(isDisappearing ? 0.2 : 1)
          .blur(radius: isDisappearing ? 100 : 0)
          .animation(.easeInOut, value: (!viewModel.isEmailValid && !viewModel.isEmailEmpty))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Button {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        let animationDuration: CGFloat = 1
        withAnimation(.spring(duration: animationDuration)) {
          // 🎬 isDisappearing animation trigger point
          isDisappearing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 0.6) {
          withAnimation {
            // ➡️ push step
            stepRouter.pushStep()
          }
        }
      } label: {
        Text("다음")
          .frame(width: 148)
      }
      .buttonStyle(CAKKButtonStyle_Large())
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
      .opacity(viewModel.isEmailValid && !viewModel.isEmailEmpty ? 1.0 : 0.3)
      .disabled(!viewModel.isEmailValid || viewModel.isEmailEmpty)
      .animation(.easeInOut, value: !viewModel.isEmailValid || viewModel.isEmailEmpty)
    }
    .ignoresSafeArea(.keyboard)
    .overlay {
      VStack(spacing: 0) {
        StepNavigationView(title: "\(stepRouter.currentStep + 1) / \(stepRouter.steps.count)") {
          // ⬅️ pop step
          stepRouter.popStep()
        }
        
        Spacer()
      }
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        // 🎬 isShowing animation trigger point
        isShowing = true
      }
    }
  }
}

struct SignUp_Email_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])
  
  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()
      
      SignUp_Email()
        .environmentObject(coordinator)
    }
  }
}
