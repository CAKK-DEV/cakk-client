//
//  OnboardingStepCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 5/2/24.
//

import SwiftUI
import CommonUtil

import DesignSystem

public struct OnboardingStepCoordinator: View {
  
  // MARK: - Properties
  
  /// onboarding step이 변해도 gradient background는 새로 업데이트 되는것을 막기 위해 State var로 관리
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")                                                         
    ])
  
  @StateObject private var stepRouter: StepRouter
  
  public init() {
    _stepRouter = StateObject(wrappedValue: StepRouter(steps: [
      AnyView(OnboardingStep_Logo()),
      AnyView(OnboardingStep_Welcome()),
      AnyView(Onboarding_WhatWeDo1()),
      AnyView(Onboarding_WhatWeDo2()),
      AnyView(Onboarding_LetsGetStarted())
    ]))
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      gradientBackground
      
      stepRouter.steps[stepRouter.currentStep]
        .environmentObject(stepRouter)
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}


// MARK: - Preview

#Preview {
  OnboardingStepCoordinator()
}
