//
//  Onboarding_WhatWeDo1.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

import DesignSystem
import Router

struct Onboarding_WhatWeDo1: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var stepRouter: StepRouter
  @State private var isShowing = false
  @State private var isDisappearing = false
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      VStack {
        Text("케이크크는 사용자가 원하는\n케이크샵을 손쉽게 찾을 수 있도록\n도와주려고 해요!")
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
      
      CKButtonLargeStroked(title: "다음", action: {
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
      .frame(width: 148)
      .largeButtonShadow()
      .padding(28)
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        isShowing = true
      }
    }
  }
}

struct Onboarding_WhatWeDo1_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])
  
  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()
      
      Onboarding_WhatWeDo1()
        .environmentObject(coordinator)
    }
  }
}
