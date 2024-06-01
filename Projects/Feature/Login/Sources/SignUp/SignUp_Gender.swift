//
//  SignUp_Gender.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

import DesignSystem
import Router

struct SignUp_Gender: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var stepRouter: StepRouter
  @State private var isShowing = false
  @State private var isDisappearing = false
  
  enum Gender: CaseIterable {
    case woman
    case man
    case unknown
    
    var description: String {
      switch self {
      case .woman:
        return "여성"
      case .man:
        return "남성"
      case .unknown:
        return "미공개"
      }
    }
    
    var icon: String {
      switch self {
      case .woman:
        return "🙋‍♀️"
      case .man:
        return "🙋‍♂️"
      case .unknown:
        return "👤"
      }
    }
  }
  
  @State private var selectedGender: Gender?
  
  
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
          genderSelectorItem(gender: .woman, isSelected: selectedGender == .woman)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .offset(x: isShowing ? 0 : 40)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(x: selectedGender == .woman && isDisappearing ? 100 : 0)
            .offset(y: selectedGender == .woman && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)
          
          genderSelectorItem(gender: .man, isSelected: selectedGender == .man)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(y: selectedGender == .man && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)
          
          genderSelectorItem(gender: .unknown, isSelected: selectedGender == .unknown)
            // isShowing animation
            .scaleEffect(isShowing ? 1.0 : 0.8)
            .blur(radius: isShowing ? 0 : 30)
            .offset(x: isShowing ? 0 : -40)
            .animation(.spring.delay(0.3), value: isShowing)
            // isDisappearing animation
            .offset(x: selectedGender == .unknown && isDisappearing ? -100 : 0)
            .offset(y: selectedGender == .unknown && isDisappearing ? -(UIScreen.main.bounds.height / 2) : 0)
            .scaleEffect(isDisappearing ? 0.4 : 1)
            .blur(radius: isDisappearing ? 100 : 0)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      CKButtonLargeStroked(title: "다음", action: {
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
      .frame(width: 148)
      .largeButtonShadow()
      .modifier(BouncyPressEffect())
      .padding(28)
      .opacity(selectedGender == nil ? 0.3 : 1.0)
      .disabled(selectedGender == nil)
      .animation(.easeInOut, value: selectedGender == nil)
    }
    .overlay {
      VStack(spacing: 0) {
        StepNavigationView(title: "\(stepRouter.currentStep + 1) / \(stepRouter.steps.count)", onTapBackButton: {
          withAnimation {
            // ⬅️ pop step
            stepRouter.popStep()
          }
        })
        
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
      selectedGender = gender
    } label: {
      VStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 14)
          .fill(selectedGender == gender ? .white : .white.opacity(0.4))
          .size(60)
          .overlay {
            Text(gender.icon)
              .font(.system(size: 27))
          }
        
        Text(gender.description)
          .font(.pretendard(size: 15, weight: .bold))
          .foregroundStyle(Color.black)
      }
    }
    .modifier(BouncyPressEffect())
  }
}


// MARK: - Preview

struct SignUp_Gender_Preview: PreviewProvider {
  static let coordinator = StepRouter(steps: [])
  
  static var previews: some View {
    ZStack {
      Color.gray.ignoresSafeArea()
      
      SignUp_Gender()
        .environmentObject(coordinator)
    }
  }
}
