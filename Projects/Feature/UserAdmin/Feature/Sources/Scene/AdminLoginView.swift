//
//  AdminLoginView.swift
//  FeatureUserAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import SwiftUIUtil

import Router
import DIContainer

public struct AdminLoginView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: AdminLoginViewModel
  @EnvironmentObject var router: Router
  
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(AdminLoginViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      gradientBackground
      
      VStack {
        DesignSystemAsset.logo.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 60)
          .padding(.bottom, 100)
      }
      
      VStack {
        CKButtonLargeMessage(
          title: "로그인",
          message: "구글로 로그인",
          action: {
            viewModel.signInWithGoogle()
          }, isLoading: .constant(viewModel.signingState == .loading)
        )
        .padding()
        
        Text("어드민 계정으로 로그인 해주세요")
          .font(.pretendard(size: 15, weight: .semiBold))
          .foregroundStyle(Color.black.opacity(0.5))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onChange(of: viewModel.signingState) { signingState in
      switch signingState {
      case .loading:
        LoadingManager.shared.startLoading()
        return
      case .appleSingInExpired:
        DialogManager.shared.showDialog(
          title: "애플 로그인 실패",
          message: "이미 애플 로그인에 시도 하였기에 설정 > AppleID > 로그인 및 보안 > Apple로 로그인 에서 케이크크 애플아이디 사용중단 후 다시 시도하여주세요.",
          primaryButtonTitle: "설정으로 이동",
          primaryButtonAction: .custom({
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsUrl)
            }
          }),
          secondaryButtonTitle: "취소",
          secondaryButtonAction: .cancel)
        
      case .serverError:
        DialogManager.shared.showDialog(.serverError())
        
      case .failure:
        DialogManager.shared.showDialog(.unknownError())
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    }
  }
}


// MARK: - Preview

import PreviewSupportUser

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(AdminLoginViewModel.self) { _ in
    let socialLoginSignInUseCase = MockSocialLoginSignInUseCase()
    let socialLoginSignUpUseCase = MockSocialLoginSignUpUseCase()
    return AdminLoginViewModel(signInUseCase: socialLoginSignInUseCase,
                               signUpUseCase: socialLoginSignUpUseCase)
  }
  return AdminLoginView()
}
