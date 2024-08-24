//
//  FeatureUserAssembly.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import FeatureUser
import DomainUser
import NetworkUser
import DomainSearch

import NetworkImage

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
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignInUseCaseImpl(socialLoginRepository: socialLoginRepository)
    }
    
    container.register(SocialLoginSignUpUseCase.self) { resolver in
      let socialLoginRepository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignUpUseCaseImpl(socialLoginRepository: socialLoginRepository)
    }
    
    container.register(SocialLoginSignOutUseCase.self) { resolver in
      let repository = resolver.resolve(SocialLoginRepository.self)!
      return SocialLoginSignOutUseCaseImpl(socialLoginRepository: repository)
    }
    
    container.register(SocialLoginViewModel.self) { resolver in
      let signInUseCase = resolver.resolve(SocialLoginSignInUseCase.self)!
      return SocialLoginViewModel(signInUseCase: signInUseCase)
    }.inObjectScope(.transient)
    
    container.register(UserProfileRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<UserAPI>.self)!
      return UserProfileRepositoryImpl(provider: provider)
    }
    
    container.register(UserProfileUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return UserProfileUseCaseImpl(repository: repository)
    }

    container.register(WithdrawUseCase.self) { resolver in
      let repository = resolver.resolve(UserProfileRepository.self)!
      return WithdrawUseCaseImpl(repository: repository)
    }
    
    container.register(ProfileViewModel.self) { resolver in
      let userProfileUseCase = resolver.resolve(UserProfileUseCase.self)!
      return ProfileViewModel(userProfileUseCase: userProfileUseCase)
    }.inObjectScope(.container)
    
    container.register(MyShopIdUseCase.self) { resolver in
      let userProfileRepository = resolver.resolve(UserProfileRepository.self)!
      return MyShopIdUseCaseImpl(repository: userProfileRepository)
    }
    
    container.register(UpdateUserProfileUseCase.self) { resolver in
      let userProfileRepository = resolver.resolve(UserProfileRepository.self)!
      let imageUploadRepository = resolver.resolve(ImageUploadRepository.self)!
      return UpdateUserProfileUseCaseImpl(userProfileRepository: userProfileRepository,
                                          imageUploadRepository: imageUploadRepository)
    }
    
    container.register(SearchMyShopViewModel.self) { resolver in
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return SearchMyShopViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
    }
    
    
    // MARK: - Email verification
    
    container.register(MoyaProvider<EmailVerificationAPI>.self) { _ in
      MoyaProvider<EmailVerificationAPI>()
    }
    
    container.register(EmailVerificationRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<EmailVerificationAPI>.self)!
      return EmailVerificationRepositoryImpl(provider: provider)
    }
    
    container.register(SendVerificationCodeUseCase.self) { resolver in
      let repository = resolver.resolve(EmailVerificationRepository.self)!
      return SendVerificationCodeUseCaseImpl(repository: repository)
    }
    
    container.register(ConfirmVerificationCodeUseCase.self) { resolver in
      let repository = resolver.resolve(EmailVerificationRepository.self)!
      return ConfirmVerificationCodeUseCaseImpl(repository: repository)
    }
    
    container.register(EmailVerificationViewModel.self) { resolver in
      let sendVerificationCodeUseCase = resolver.resolve(SendVerificationCodeUseCase.self)!
      let confirmVerificationCodeUseCase = resolver.resolve(ConfirmVerificationCodeUseCase.self)!
      return EmailVerificationViewModel(sendVerificationCodeUseCase: sendVerificationCodeUseCase,
                                        confirmVerificationCodeUseCase: confirmVerificationCodeUseCase)
    }
  }
}
