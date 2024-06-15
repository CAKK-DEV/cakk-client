//
//  ExampleApp.swift
//  CAKK
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Router

import FeatureUser

import DomainUser
import DomainOAuthToken

import NetworkUser

import Moya
import MoyaUtil

import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

import UserSession

import DIContainer

@main
struct ExampleApp: App {
  
  // MARK: - Properties
  
  @StateObject var router = Router()
  private var diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  init() {
    initKakaoSDK()
    setupDIContainer()
  }
  
  
  // MARK: - Views
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navPath) {
        UserCoordinator()
          .environmentObject(router)
      }
      .onOpenURL { url in
        // Kakao 인증 리디렉션 URL 처리
        if AuthApi.isKakaoTalkLoginUrl(url) {
          _ = AuthController.handleOpenUrl(url: url)
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
    diContainer.register(MoyaProvider<UserAPI>.self) { _ in
      #if STUB
      MoyaProvider<UserAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(SocialLoginRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return SocialLoginRepositoryImpl(provider: provider)
    }
    
    diContainer.register(SocialLoginSignInUseCase.self) { resolver in
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: socialLoginRepository)
    }
    
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: socialLoginRepository)
    }
    
    diContainer.register(SocialLoginViewModel.self) { resolver in
      let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let signUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return SocialLoginViewModel(signInUseCase: signInUseCase,
                                  signUpUseCase: signUpUseCase)
    }.inObjectScope(.transient)
    
    diContainer.register(UserProfileRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return UserProfileRepositoryImpl(provider: provider)
    }
    
    diContainer.register(UserProfileUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return UserProfileUseCaseImpl(repository: repository)
    }
    
    diContainer.register(UpdateUserProfileUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return UpdateUserProfileUseCaseImpl(repository: repository)
    }
    
    diContainer.register(WithdrawUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return WithdrawUseCaseImpl(repository: repository)
    }
    
    diContainer.register(ProfileViewModel.self) { resolver in
      let userProfileUseCase = resolver.resolve(UserProfileUseCase.self)!
      return ProfileViewModel(userProfileUseCase: userProfileUseCase)
    }.inObjectScope(.container)
  }
  
  private func initKakaoSDK() {
    if let appKey = Bundle.main.infoDictionary?["KAKAO_SDK_APP_KEY"] as? String {
      KakaoSDK.initSDK(appKey: appKey)
    } else {
      assertionFailure("🔑 유효하지 않은 카카오 APP key 입니다.")
    }
  }
}
