//
//  SignUp_Processing.swift
//  FeatureUser
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

struct SignUp_Processing: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var stepRouter: StepRouter
  @EnvironmentObject private var viewModel: SocialLoginViewModel
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 28) {
      ProgressView()
        .controlSize(.regular)
        .tint(Color.white)
      
      Text("게정 생성중...")
        .font(.pretendard(size: 27, weight: .bold))
        .foregroundStyle(Color.white)
        .whiteTextShadow()
    }
    .padding(.bottom, 48)
    .onAppear {
      viewModel.signUp()
    }
    .onChange(of: viewModel.signUpState) { state in
      switch state {
      case .failure, .serverError:
        stepRouter.popToRoot()
      case .success:
        router.replace(with: LoginPublicDestination.home)
      default:
        break
      }
    }
  }
}


// MARK: - Preview

//#Preview {
//  ZStack {
//    Color.gray.ignoresSafeArea()
//    SignUp_Processing()
//  }
//}
