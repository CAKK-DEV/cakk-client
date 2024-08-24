//
//  SignUpStepNavigationView.swift
//  FeatureUser
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DIContainer
import LinkNavigator

public struct SignUpStepNavigationView: View {
  
  // MARK: - Properties
  
  private let navigator: LinkNavigatorType?
  
  @EnvironmentObject private var stepRouter: StepRouter
  @State private var isAppearing = false
  
  
  // MARK: - Initializers
  
  public init() {
    let container = DIContainer.shared.container
    self.navigator = container.resolve(LinkNavigatorType.self)
  }
  
  // MARK: - Views
  
  public var body: some View {
    HStack {
      Spacer()
        .overlay {
          HStack {
            Button {
              if stepRouter.currentStep == 0 {
                navigator?.backToLast(path: "login", isAnimated: false)
              } else {
                stepRouter.popStep()
              }
            } label: {
              Image(systemName: "chevron.left")
                .font(.system(size: 24))
                .foregroundStyle(Color.white)
            }
            
            Spacer()
          }
          .padding(20)
        }
      
      Text("\(stepRouter.currentStep + 1) / \(stepRouter.steps.count)")
        .font(.system(size: 20, weight: .bold, design: .rounded))
        .foregroundStyle(Color.white.opacity(0.5))
        .scaleEffect(isAppearing ? 1.0 : 1.2)
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 72)
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        isAppearing = true
      }
    }
  }
}


// MARK: - Preview

#Preview {
  struct PreviewContent: View {
    @StateObject var stepRouter = StepRouter(steps: [
      AnyView(EmptyView()),
      AnyView(EmptyView()),
      AnyView(EmptyView())
    ])
    
    var body: some View {
      SignUpStepNavigationView()
        .background(Color.black)
    }
  }
  
  return PreviewContent()
}
