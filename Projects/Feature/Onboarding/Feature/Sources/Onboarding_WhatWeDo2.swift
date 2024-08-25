//
//  Onboarding_WhatWeDo2.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import CommonUtil
import DesignSystem

struct Onboarding_WhatWeDo2: View {

  // MARK: - Properties

  @EnvironmentObject private var stepRouter: StepRouter
  @State private var isShowing = false
  @State private var isDisappearing = false


  // MARK: - Views

  var body: some View {
    VStack(spacing: 0) {
      VStack {
        Text("또, 케이크샵 사장님에게는\n매장을 효과적으로 홍보할 수\n있도록 하여 많은 사용자와의\n만남을 꿈꾸고 있어요!")
          .font(.pretendard(size: 27, weight: .bold))
          .foregroundStyle(Color.white)
          .whiteTextShadow()
          .multilineTextAlignment(.center)
          .padding()
          // isShowing animation
          .offset(x: 0, y: isShowing ? 0 : 120)
          .scaleEffect(isShowing ? 1.0 : 0.95)
          .opacity(isShowing ? 1.0 : 0)
          .blur(radius: isShowing ? 0 : 10)
          // isDisappearing animation
          .blur(radius: isDisappearing ? 1000 : 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      CKButtonLargeStroked(title: "다음", fixedSize: 148, action: {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        let animationDuration: CGFloat = 1
        withAnimation(.easeIn(duration: animationDuration)) {
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
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        // 🎬 isShowing animation trigger point
        isShowing = true
      }
    }
  }
}

struct Onboarding_WhatWeDo2_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])

  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()

      Onboarding_WhatWeDo2()
        .environmentObject(coordinator)
    }
  }
}
