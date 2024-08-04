//
//  FeatureUserAssembly.swift
//  CAKK-Admin
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import FeatureUserAdmin
import DomainUser
import NetworkUser

final class FeatureUserAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<UserAPI>.self) { _ in
      #if STUB
      MoyaProvider<UserAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    container.register(SocialLoginRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return SocialLoginRepositoryImpl(provider: provider)
    }
    
    container.register(SocialLoginSignInUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: repository)
    }
    
    container.register(SocialLoginSignUpUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: repository)
    }
    
    container.register(AdminLoginViewModel.self) { resolver in
      let socialLoginSignInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      let socialLoginSignUpUseCase = resolver.resolve(SocialLoginSignUpUseCase.self)!
      return AdminLoginViewModel(signInUseCase: socialLoginSignInUseCase,
                                 signUpUseCase: socialLoginSignUpUseCase)
    }
  }
}
