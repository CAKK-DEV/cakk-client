//
//  Onboarding_Logo.swift
//  CAKK
//
//  Created by 이승기 on 5/8/24.
//

import SwiftUI
import Haptico

import DesignSystem
import Router

struct OnboardingStep_Logo: View {

  // MARK: - Properties
  
  @State private var isShowingStep1 = false
  @State private var isShowingStep2 = false
  @State private var isDisappearing = false
  
  @EnvironmentObject private var stepRouter: StepRouter
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        DesignSystemAsset.logo.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 60)
          // animation step 1
          .scaleEffect(isShowingStep1 ? 1.0 : 1.5)
          .opacity(isShowingStep1 ? 1.0 : 0)
          .blur(radius: isShowingStep1 ? 0 : 50)
          // animation step 2
          .scaleEffect(isShowingStep2 ? 1.0 : 1.25)
          .blur(radius: isShowingStep2 ? 0 : 15)
          // disappearing
          .blur(radius: isDisappearing ? 50 : 0)
          .opacity(isDisappearing ? 0 : 1.0)
      }
      .padding(.bottom, 120)
    }
    .onAppear {
      Haptico.shared().generateFeedbackFromPattern("......oooooO", delay: 0.03)
      dismiss(after: 3)
      
      withAnimation(.easeOut(duration: 1.67)) {
        // 🎬 animation step 1 trigger point
        isShowingStep1 = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          withAnimation(.bouncy) {
            // 🎬 animation step 2 trigger point
            isShowingStep2 = true
          }
        }
      }
    }
  }
  
  
  // MARK: - Methods
  
  private func dismiss(after time: CGFloat) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      withAnimation(.smooth(duration: 1.2)) {
        isDisappearing = true
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
        withAnimation {
          // ➡️ push step
          stepRouter.pushStep()
        }
      }
    }
  }
}


// MARK: - Preview

struct OnboardingStep_Logo_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])
  
  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()
      
      OnboardingStep_Logo()
        .environmentObject(coordinator)
    }
  }
}
