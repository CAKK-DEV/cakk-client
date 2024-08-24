//
//  SignUp_Email.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import CommonUtil
import DesignSystem
import DIContainer

struct SignUp_Email: View {

  // MARK: - Properties

  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var signUpViewModel: SocialLoginSignUpViewModel
  
  @StateObject private var emailVerificationViewModel: EmailVerificationViewModel
  @State private var isShowing = false
  @State private var isDisappearing = false
  
  @FocusState private var isVerificationCodeInputFieldFocused
  

  // MARK: - Initializers

  init() { 
    let emailVerificationViewModel = DIContainer.shared.container.resolve(EmailVerificationViewModel.self)!
    _emailVerificationViewModel = .init(wrappedValue: emailVerificationViewModel)
  }


  // MARK: - Views

  var body: some View {
    switch emailVerificationViewModel.emailVerificationState {
    case .idle, .sendingRequestVerificationCode, .timeExpired, .verified:
      emailInputView()
        .onAppear {
          withAnimation(.bouncy(duration: 1)) {
            // 🎬 isShowing animation trigger point
            isShowing = true
          }
        }
    default:
      emailVerificationInputView()
    }
  }
  
  private func emailInputView() -> some View {
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

          if !signUpViewModel.isEmailValid && !signUpViewModel.isEmailEmpty {
            Text("이메일 형식이 올바르지 않아요")
              .font(.pretendard(size: 15, weight: .medium))
              .foregroundStyle(DesignSystemAsset.brandcolor2.swiftUIColor)
          }
        }
        .animation(.easeInOut, value: (!signUpViewModel.isEmailValid && !signUpViewModel.isEmailEmpty))

        TextField("email", text: $signUpViewModel.userData.email)
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
          .disabled(emailVerificationViewModel.emailVerificationState == .sendingRequestVerificationCode)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "인증번호 발송", action: {
        withAnimation {
          emailVerificationViewModel.sendVerificationCodeThrough(email: signUpViewModel.userData.email)
        }
      }, isLoading: .constant(emailVerificationViewModel.emailVerificationState == .sendingRequestVerificationCode))
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
      .opacity(signUpViewModel.isEmailValid && !signUpViewModel.isEmailEmpty ? 1.0 : 0.3)
      .animation(.easeInOut, value: !signUpViewModel.isEmailValid || signUpViewModel.isEmailEmpty)
    }
    .ignoresSafeArea(.keyboard)
    .overlay {
      VStack(spacing: 0) {
        SignUpStepNavigationView()
        Spacer()
      }
    }
  }
  
  private func emailVerificationInputView() -> some View {
    VStack(spacing: 0) {
      VStack(spacing: 44) {
        VStack(spacing: 8) {
          Text("이메일로 인증번호를 발송했어요\n인증번호를 입력해 주세요")
            .font(.pretendard(size: 23, weight: .bold))
            .foregroundStyle(Color.white)
            .whiteTextShadow()
            .multilineTextAlignment(.center)

          if emailVerificationViewModel.emailVerificationState == .notMatched {
            Text("인증번호가 올바르지 않아요")
              .font(.pretendard(size: 15, weight: .medium))
              .foregroundStyle(DesignSystemAsset.brandcolor2.swiftUIColor)
          }
        }
        // isDisappearing animation
        .offset(y: isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
        .scaleEffect(isDisappearing ? 0.4 : 1)
        .blur(radius: isDisappearing ? 100 : 0)

        HStack(spacing: 16) {
          TextField("000000", text: $emailVerificationViewModel.verificationCode)
            .keyboardType(.numberPad)
            .font(.pretendard(size: 28, weight: .bold))
            .foregroundStyle(Color.white)
            .frame(width: 112)
            .disabled(emailVerificationViewModel.emailVerificationState == .requestConfirmVerificationCode)
            .focused($isVerificationCodeInputFieldFocused)
            .onChange(of: emailVerificationViewModel.verificationCode) { verificationCode in
              if verificationCode.count > 6 {
                emailVerificationViewModel.verificationCode = String(verificationCode.prefix(6))
              }
              
              if verificationCode.count == 6 {
                isVerificationCodeInputFieldFocused = false
              }
            }
          
          Text(String(format: "%d:%02d", emailVerificationViewModel.timeRemaining / 60, emailVerificationViewModel.timeRemaining % 60))
            .font(.pretendard(size: 20, weight: .bold))
            .frame(width: 46)
            .foregroundStyle(.white.opacity(0.5))
        }
        .frame(height: 56)
        .padding(.horizontal, 24)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.3), lineWidth: 3)
        }
        // isDisappearing animation
        .offset(y: isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
        .scaleEffect(isDisappearing ? 0.2 : 1)
        .blur(radius: isDisappearing ? 100 : 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "인증하기", action: {
        emailVerificationViewModel.confirmVerificationCode(email: signUpViewModel.userData.email)
      }, isLoading: .constant(emailVerificationViewModel.emailVerificationState == .requestConfirmVerificationCode))
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
      .opacity(emailVerificationViewModel.isVerificationCodeValid ? 1.0 : 0.3)
      .disabled(!emailVerificationViewModel.isVerificationCodeValid)
      .disabled(emailVerificationViewModel.emailVerificationState == .requestConfirmVerificationCode)
      .disabled(emailVerificationViewModel.emailVerificationState == .verified) /// 연속 클릭 시 중복 인증 요청 방지
    }
    .animation(.easeInOut, value: emailVerificationViewModel.emailVerificationState)
    .ignoresSafeArea(.keyboard)
    .overlay {
      VStack(spacing: 0) {
        SignUpStepNavigationView()
        Spacer()
      }
    }
    .onReceive(emailVerificationViewModel.$emailVerificationState) { newState in
      switch newState {
      case .confirmVerificationCodeFailure:
        DialogManager.shared.showDialog(title: "인증번호 확인에 실패하였어요",
                                        message: "다시 시도하여주세요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
      
      case .requestVerificationCodeFailure:
        DialogManager.shared.showDialog(title: "인증번호 요청에 실패하였어요",
                                        message: "다시 시도하여주세요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
        
      case .serverError:
        DialogManager.shared.showDialog(.serverError())
        
      case .notMatched:
        DialogManager.shared.showDialog(title: "인증번호가 일치하지 않아요",
                                        message: "인증번호 확인 후 다시 시도하여주세요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
        
      case .verified:
        pushToNextStep()
      
      default:
        break
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func pushToNextStep() {
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
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  @StateObject var stepRouter = StepRouter(steps: [])
  @StateObject var signUpViewModel: SocialLoginSignUpViewModel
  @StateObject var emailVerificationViewModel: EmailVerificationViewModel

  init() {
    let emailVerificationViewModel = EmailVerificationViewModel(sendVerificationCodeUseCase: MockSendVerificationCodeUseCase(),
                                                            confirmVerificationCodeUseCase: MockConfirmVerificationCodeUseCase())
    _emailVerificationViewModel = .init(wrappedValue: emailVerificationViewModel)
    
    let signUpViewModel = SocialLoginSignUpViewModel(
      loginType: .kakao,
      userData: UserData(nickname: "", email: "", birthday: .now, gender: .unknown),
      credentialData: .init(loginProvider: .kakao, idToken: ""),
      signUpUseCase: MockSocialLoginSignUpUseCase()
    )
    _signUpViewModel = .init(wrappedValue: signUpViewModel)
  }

  var body: some View {
    SignUp_Email()
      .environmentObject(stepRouter)
      .environmentObject(signUpViewModel)
      .environmentObject(emailVerificationViewModel)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    PreviewContent()
  }
}
