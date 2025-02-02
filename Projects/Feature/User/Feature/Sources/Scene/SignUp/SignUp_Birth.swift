//
//  SignUp_Birth.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import CommonUtil
import DesignSystem

import DIContainer
import LinkNavigator

struct SignUp_Birth: View {

  // MARK: - Properties

  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var viewModel: SocialLoginSignUpViewModel
  @State private var isShowing = false
  @State private var isDisappearing = false

  private let birthDateFormatter: DateFormatter
  private let navigator: LinkNavigatorType?


  // MARK: - Initializers

  init() {
    birthDateFormatter = DateFormatter()
    birthDateFormatter.dateFormat = "yyyy MM dd"
    
    let container = DIContainer.shared.container
    self.navigator = container.resolve(LinkNavigatorType.self)
  }


  // MARK: - Views

  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 24) {
        VStack(spacing: 8) {
          VStack(spacing: 4) {
            Text("생년월일을 선택해 주세요")
              .font(.pretendard(size: 27, weight: .bold))
              .foregroundStyle(Color.white)
              .whiteTextShadow()

            Text("생일 정보는 맞춤형 콘텐츠 제공 및 이벤트\n참여를 위해 필요해요")
              .font(.pretendard(size: 15, weight: .semiBold))
              .foregroundStyle(Color.white.opacity(0.5))
          }
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
        }

        Text(viewModel.userData.birthday.formatted(.dateTime.day().month().year()))
          .font(.pretendard(size: 27, weight: .bold))
          .frame(width: 295, height: 56)
          .background {
            RoundedRectangle(cornerRadius: 20)
              .stroke(Color.white.opacity(0.3), lineWidth: 3)
          }
          .foregroundColor(.white)
          .overlay {
            DatePicker(selection: $viewModel.userData.birthday, in: ...Date(), displayedComponents: .date) {}
              .labelsHidden()
              .contentShape(Rectangle())
              .opacity(0.011)
          }
          // isShowing animation
          .scaleEffect(isShowing ? 1.0 : 0.95)
          .opacity(isShowing ? 1.0 : 0)
          // isDisappearing animation
          .offset(y: isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
          .scaleEffect(isDisappearing ? 0.2 : 1)
          .blur(radius: isDisappearing ? 100 : 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "완료", fixedSize: 148, action: {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

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
        .overlay {
          HStack {
            Button {
              stepRouter.pushStep()
            } label: {
              Text("건너뛰기")
                .font(.pretendard(size: 17, weight: .semiBold))
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.vertical, 12)
                .padding(.trailing, 20)
            }
          }
          .frame(maxWidth: .infinity, alignment: .trailing)
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
    SignUp_Birth()
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
