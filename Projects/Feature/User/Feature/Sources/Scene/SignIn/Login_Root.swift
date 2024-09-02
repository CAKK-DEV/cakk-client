//
//  Login_Root.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

import DesignSystem
import CommonUtil

import DIContainer
import AnalyticsService

import LinkNavigator

struct Login_Root: View {

  // MARK: - Properties

  @StateObject private var viewModel: SocialLoginSignInViewModel

  @State private var isShowing = false
  @State private var isShowingAppleSignInExpiredAlert = false
  
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    
    _viewModel = .init(wrappedValue: diContainer.resolve(SocialLoginSignInViewModel.self)!)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }


  // MARK: - Views

  var body: some View {
    ZStack {
      gradientBackground
        .clipped()
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        VStack(spacing: 44) {
          Text("다음 방법들 중 하나로\n로그인 해주세요")
            .font(.system(size: 27, weight: .bold))
            .foregroundStyle(Color.white)
            .whiteTextShadow()
            .multilineTextAlignment(.center)
            .padding()
            // isShowing animation
            .offset(x: 0, y: isShowing ? 0 : 120)
            .scaleEffect(isShowing ? 1.0 : 0.95)
            .opacity(isShowing ? 1.0 : 0)
            .blur(radius: isShowing ? 0 : 10)

          HStack(spacing: 16) {
            loginButton(image: DesignSystemAsset.logoKakao.swiftUIImage, loginAction: {
              viewModel.signInWithKakao()
            })
              // isShowing animation
              .scaleEffect(isShowing ? 1.0 : 0.7)
              .opacity(isShowing ? 1.0 : 0)
              .blur(radius: isShowing ? 0 : 10)
              .animation(.bouncy(duration: 1).delay(0.2), value: isShowing)

            loginButton(image: DesignSystemAsset.logoApple.swiftUIImage, loginAction: {
              viewModel.signInWithApple()
            })
              // isShowing animation
              .scaleEffect(isShowing ? 1.0 : 0.7)
              .opacity(isShowing ? 1.0 : 0)
              .blur(radius: isShowing ? 0 : 10)
              .animation(.bouncy(duration: 1).delay(0.4), value: isShowing)

            loginButton(image: DesignSystemAsset.logoGoogle.swiftUIImage, loginAction: {
              viewModel.signInWithGoogle()
            })
              // isShowing animation
              .scaleEffect(isShowing ? 1.0 : 0.7)
              .opacity(isShowing ? 1.0 : 0)
              .blur(radius: isShowing ? 0 : 10)
              .animation(.bouncy(duration: 1).delay(0.6), value: isShowing)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        Button {
          dismiss()
        } label: {
          Text("로그인 없이 둘러보기")
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(Color.black.opacity(0.3))
            .padding(43)
        }
      }
      .overlay {
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            Text("로그인")
              .font(.system(size: 30, weight: .bold))
              .foregroundStyle(Color.white)
              .whiteTextShadow()
              .padding(.leading, 20)
              .padding(.top, 40)
              .offset(x: isShowing ? 0 : -80, y: 0)
              .blur(radius: isShowing ? 0 : 10)
              .animation(.spring, value: isShowing)

            Spacer()
          }

          Spacer()
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .onFirstAppear {
      /// 처음 Login화면에 진입했다는 것은 온보딩을 모두 봤다는 뜻으로 해석할 수 있습니다.
      /// 따라서 login 화면에 진입하는 시점에 hasSeenOnboarding 값을 true로 업데이트 합니다.
      hasSeenOnboarding = true
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        // 🎬 isShowing animation trigger point
        isShowing = true
      }
      
      analytics?.logEngagement(view: self)
    }
    .onReceive(viewModel.$signInState) { loginState in
      if loginState == .loading {
        LoadingManager.shared.startLoading()
        return
      }

      LoadingManager.shared.stopLoading()

      switch loginState {
      case .loading:
        LoadingManager.shared.startLoading()
      case .loggedIn:
        dismiss()
        
      case .newUser:
        guard let loginType = viewModel.loginType else { return }
        let items = RouteHelper.SignUp.items(loginType: loginType.rawValue)
        navigator?.next(paths: [RouteHelper.SignUp.path], items: items, isAnimated: false)
        
      case .failure:
        // alert
        LoadingManager.shared.stopLoading()
      case .serverError:
        // alert
        LoadingManager.shared.stopLoading()
      case .appleSingInExpired:
        LoadingManager.shared.stopLoading()
        isShowingAppleSignInExpiredAlert = true
      default:
        break
      }
    }
    .alert("애플 로그인 실패", isPresented: $isShowingAppleSignInExpiredAlert) {
      Button("취소", role: .cancel, action: {})
      Button("설정으로 이동", role: .none, action: {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(settingsUrl)
        }
      })
    } message: {
      Text("이미 애플 로그인에 시도 하였기에 설정 > AppleID > 로그인 및 보안 > Apple로 로그인 에서 케이크크 애플아이디 사용중단 후 다시 시도하여주세요.")
    }
  }

  private func loginButton(image: Image, loginAction: @escaping () -> Void) -> some View {
    Button {
      UIImpactFeedbackGenerator(style: .light).impactOccurred()
      loginAction()
    } label: {
      RoundedRectangle(cornerRadius: 14)
        .fill(Color.white.opacity(0.4))
        .size(60)
        .overlay {
          image
            .resizable()
            .size(24)
            .foregroundStyle(Color.black)
        }
    }
    .modifier(BouncyPressEffect())
  }
  
 
  // MARK: - Private Methods
  
  private func dismiss() {
    if navigator?.rootCurrentPaths.first == RouteHelper.TabRoot.path {
      navigator?.back(isAnimated: true)
    } else {
      navigator?.replace(paths: [RouteHelper.TabRoot.path], items: [:], isAnimated: true)
    }
  }
}


// MARK: - Preview

import PreviewSupportUser
import DomainUser

private struct PreviewContent: View {
  @StateObject var viewModel: SocialLoginSignInViewModel

  init() {
    let viewModel = SocialLoginSignInViewModel(signInUseCase: MockSocialLoginSignInUseCase())
    _viewModel = .init(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      Color.gray.ignoresSafeArea()

      Login_Root()
        .environmentObject(viewModel)
    }
  }
}


// MARK: - Preview

#Preview {
  PreviewContent()
}
