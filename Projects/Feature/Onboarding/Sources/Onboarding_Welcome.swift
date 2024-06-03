//
//  Onboarding_Welcome.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI
import SwiftUIUtil

import DesignSystem
import Router

struct OnboardingStep_Welcome: View {

  // MARK: - Properties
  
  @State private var waveHandCount = 0
  @State private var waveHand = false
  @State private var timer = Timer.publish(every: 0.31, on: .main, in: .common).autoconnect()
  @State private var isShowing = false
  
  @EnvironmentObject private var stepRouter: StepRouter
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        Text("✋")
          .font(.system(size: 100))
          // isShowing animation
          .scaleEffect(isShowing ? 1.0 : 0.2)
          .opacity(isShowing ? 1.0 : 0)
          .offset(x: 0, y: isShowing ? 0 : 40)
          .animation(.bouncy(duration: 0.67).delay(0.67), value: isShowing)
          // 👋 hand waving animation
          .rotationEffect(.degrees(waveHand ? -30 : 10), anchor: .bottom)
          .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: waveHand)
          .onReceive(timer) { _ in
            if waveHandCount < 4 { // 한 번에 총 4번 흔들도록 (2번 빠르게, 잠깐 멈춤, 2번 빠르게)
              self.waveHand.toggle()
              waveHandCount += 1
            } else {
              self.waveHand = false // 잠깐 멈추고
              waveHandCount = 0
            }
          }
        
        Text("환영합니다")
          .font(.pretendard(size: 34, weight: .bold))
          .foregroundStyle(Color.white)
          .whiteTextShadow()
          .padding(.vertical, 20)
          // isShowing animation
          .offset(x: 0, y: isShowing ? 0 : 20)
          .scaleEffect(isShowing ? 1.0 : 0.3)
          .opacity(isShowing ? 1.0 : 0)
          .blur(radius: isShowing ? 0 : 10)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      CKButtonLargeStroked(title: "다음", fixedSize: 148, action: {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        withAnimation {
          // ➡️ push step
          stepRouter.pushStep()
        }
      })
      .largeButtonShadow()
      .padding(.vertical, 28)
      .activeAfter(0.75)
      // isShowing animation
      .opacity(isShowing ? 1.0 : 0)
      .animation(.easeInOut.delay(1.5), value: isShowing)
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        // 🎬 isShowing animation trigger point
        isShowing = true
      }
    }
    .onDisappear {
      withAnimation(.spring) {
        self.timer.upstream.connect().cancel()
      }
    }
  }
}


// MARK: - Preview

struct OnboardingStep_Welcome_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])
  
  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()
      
      OnboardingStep_Welcome()
        .environmentObject(coordinator)
    }
  }
}
