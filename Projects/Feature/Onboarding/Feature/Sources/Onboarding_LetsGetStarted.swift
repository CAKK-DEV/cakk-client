//
//  Onboarding_LetsGetStarted.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import CommonUtil
import DesignSystem
import DIContainer
import LinkNavigator

struct Onboarding_LetsGetStarted: View {

  // MARK: - Properties

  @EnvironmentObject private var stepRouter: StepRouter
  @State private var isShowing = false
  @State private var isDisappearing = false
  
  private let navigator: LinkNavigatorType?
  
  public init() {
    let container = DIContainer.shared.container
    navigator = container.resolve(LinkNavigatorType.self)
  }


  // MARK: - Views

  var body: some View {
    VStack(spacing: 0) {
      VStack {
        Text("그럼 시작해 볼까요?")
          .font(.pretendard(size: 36, weight: .bold))
          .foregroundStyle(Color.white)
          .whiteTextShadow()
          .multilineTextAlignment(.center)
          .padding()
          // isShowing animation
          .scaleEffect(isShowing ? 1.0 : 0.95)
          .opacity(isShowing ? 1.0 : 0)
          .blur(radius: isShowing ? 0 : 10)
          // isDisappearing animation
          .scaleEffect(isDisappearing ? 20 : 1)
          .opacity(isDisappearing ? 0 : 1.0)
          .blur(radius: isDisappearing ? 1000 : 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "로그인", fixedSize: 148, action: {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        let animationDuration: CGFloat = 2
        withAnimation(.easeIn(duration: animationDuration)) {
          // 🎬 isDisappearing animation trigger point
          isDisappearing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 1.4) {
          withAnimation {
            // ➡️ Finish step
            navigator?.replace(paths: [RouteHelper.Login.path], items: [:], isAnimated: true)
          }
        }
      })
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
      // idDisappearing animation
      .blur(radius: isDisappearing ? 100 : 0)
      .scaleEffect(isDisappearing ? 0.01: 1.0)
      .opacity(isDisappearing ? 0 : 1.0)
      .animation(.easeIn(duration: 0.4), value: isDisappearing)
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        // 🎬 isShowing animation trigger point
        isShowing = true
      }
    }
  }
}

struct Onboarding_LetsGetStarted_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])

  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()

      Onboarding_LetsGetStarted()
        .environmentObject(coordinator)
    }
  }
}
