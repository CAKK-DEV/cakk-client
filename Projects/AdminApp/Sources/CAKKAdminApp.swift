//
//  CAKKAdminApp.swift
//  CAKK-Admin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Moya
import MoyaUtil

import FeatureUserAdmin
import DomainUser
import NetworkUser

import Router
import DIContainer

@main
struct CAKKAdminApp: App {
  
  // MARK: - Properties
  
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  init() {
    setupDIContainer()
  }
  
  
  // MARK: - Internal Methods
  
  var body: some Scene {
    WindowGroup {
      AppCoordinator()
    }
  }
  
  
  // MARK: - Private Methods
  
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
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: repository)
    }
    
    diContainer.register(SocialLoginSignUpUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: repository)
    }
    
    diContainer.register(AdminLoginViewModel.self) { resolver in
      let socialLoginSignInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let socialLoginSignUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return AdminLoginViewModel(signInUseCase: socialLoginSignInUseCase,
                                 signUpUseCase: socialLoginSignUpUseCase)
    }
  }
}
