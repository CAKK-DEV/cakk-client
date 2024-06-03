//
//  ExampleApp.swift
//  CAKK
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureLogin

import DomainUser
import DomainOAuthToken

import NetworkUser
import OAuthToken

import DIContainer

import Moya
import MoyaUtil

import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct ExampleApp: App {
  
  // MARK: - Properties
  
  private var diContainer: DIContainerProtocol
  
  
  // MARK: - Initializers
  
  init() {
    diContainer = SwinjectDIContainer()
    initKakaoSDK()
    setupDIContainer()
  }
  
  
  // MARK: - Views
  
  var body: some Scene {
    WindowGroup {
      LoginStepCoordinator(diContainer: diContainer)
        .onOpenURL { url in
          // Kakao 인증 리디렉션 URL 처리
          if AuthApi.isKakaoTalkLoginUrl(url) {
            AuthController.handleOpenUrl(url: url)
            return
          }
          
          // Google 인증 리디렉션 URL 처리
          if GIDSignIn.sharedInstance.handle(url) {
            return
          }
        }
    }
  }
  
  
  // MARK: - Private Method
  
  private func setupDIContainer() {
    diContainer.register(MoyaProvider<SocialLoginAPI>.self) { _ in
      MoyaProvider<SocialLoginAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    diContainer.register(SocialLoginRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SocialLoginAPI>.self)!
      return SocialLoginRepositoryImpl(provider: provider)
    }
    
    diContainer.register(OAuthTokenRepository.self) { _ in
      OAuthTokenRepositoryImpl()
    }
    
    diContainer.register(SocialLoginSignInUseCase.self) { resolver in
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      let oauthTokenRepository = resolver.resolve(OAuthTokenRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: socialLoginRepository,
                                          oauthTokenRepository: oauthTokenRepository)
    }
    
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      let oauthTokenRepository = resolver.resolve(OAuthTokenRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: socialLoginRepository,
                                          oauthTokenRepository: oauthTokenRepository)
    }
    
    diContainer.register(SocialLoginViewModel.self) { resolver in
      SocialLoginViewModel(diContainer: resolver)
    }
  }
  
  private func initKakaoSDK() {
    if let appKey = Bundle.main.infoDictionary?["KAKAO_SDK_APP_KEY"] as? String {
      KakaoSDK.initSDK(appKey: appKey)
    } else {
      assertionFailure("🔑 유효호지 않은 카카오 APP key 입니다.")
    }
  }
}
