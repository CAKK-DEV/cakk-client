//
//  SignUp_Gender.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import CommonUtil
import DesignSystem

struct SignUp_Gender: View {

  // MARK: - Properties

  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var viewModel: SocialLoginSignUpViewModel
  @State private var isShowing = false
  @State private var isDisappearing = false


  // MARK: - Initializers

  init() { }


  // MARK: - Views

  public var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 44) {
        Text("성별을 선택해 주세요")
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

        HStack(spacing: 24) {
          genderSelectorItem(gender: .female, isSelected: viewModel.userData.gender == .female)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .offset(x: isShowing ? 0 : 40)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(x: viewModel.userData.gender == .female && isDisappearing ? 100 : 0)
            .offset(y: viewModel.userData.gender == .female && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)

          genderSelectorItem(gender: .male, isSelected: viewModel.userData.gender == .male)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(y: viewModel.userData.gender == .male && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)

          genderSelectorItem(gender: .unknown, isSelected: viewModel.userData.gender == .unknown)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .offset(x: isShowing ? 0 : -40)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(x: viewModel.userData.gender == .unknown && isDisappearing ? -100 : 0)
            .offset(y: viewModel.userData.gender == .unknown && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "다음", fixedSize: 148, action: {
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
      })
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
    }
    .overlay {
      VStack(spacing: 0) {
        SignUpStepNavigationView()
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

  private func genderSelectorItem(gender: Gender, isSelected: Bool) -> some View {
    Button {
//      selectedGender = gender
      /// 뷰모델에도 gender를 업데이트 해줍니다.
      viewModel.userData.gender = gender
    } label: {
      VStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 14)
          .fill(viewModel.userData.gender == gender ? .white : .white.opacity(0.4))
          .size(60)
          .overlay {
            Text(gender.emoji)
              .font(.system(size: 27))
          }

        Text(gender.displayName)
          .font(.pretendard(size: 15, weight: .bold))
          .foregroundStyle(Color.black)
      }
    }
    .modifier(BouncyPressEffect())
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  @StateObject var stepRouter = StepRouter(steps: [])
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
    SignUp_Gender()
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
