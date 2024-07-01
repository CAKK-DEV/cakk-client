//
//  CAKKApp.swift
//  CAKK
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureUser
import DomainUser
import NetworkUser

import FeatureCakeShop
import DomainCakeShop
import NetworkCakeShop

import DomainOAuthToken
import OAuthToken
import UserSession

import FeatureSearch
import DomainSearch
import NetworkSearch
import UserDefaultsSearchHistory

import DomainBusinessOwner
import NetworkBusinessOwner

import DIContainer

import Moya
import MoyaUtil

import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth


@main
struct CAKKApp: App {
  
  // MARK: - Initializers
  
  init() {
    setupDIContainer()
    initKakaoSDK()
  }
  
  
  // MARK: - Internal
  
  var body: some Scene {
    WindowGroup {
      AppCoordinator()
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
  
  
  // MARK: - Private
  
  private func setupDIContainer() {
    let diContainer = DIContainer.shared.container
    
    // User Feature
    
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
    
    
    // CakeShop Feature
    
    diContainer.register(MoyaProvider<CakeShopAPI>.self) { _ in
      #if STUB
      MoyaProvider<CakeShopAPI>(stubClosure: { _ in .delayed(seconds: 1) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<CakeShopAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(CakeImagesByCategoryRepository.self) { resolver in
      CakeImagesByCategoryRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeShopDetailRepository.self) { resolver in
      CakeShopDetailRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeShopQuickInfoRepository.self) { resolver in
      CakeShopQuickInfoRepositoryImpl(provider: resolver.resolve(MoyaProvider<CakeShopAPI>.self)!)
    }
    
    diContainer.register(CakeImagesByCategoryUseCase.self) { resolver in
      CakeImagesByCategoryUseCaseImpl(repository: resolver.resolve(CakeImagesByCategoryRepository.self)!)
    }
    
    diContainer.register(CakeShopQuickInfoUseCase.self) { resolver in
      CakeShopQuickInfoUseCaseImpl(repository: resolver.resolve(CakeShopQuickInfoRepository.self)!)
    }
    
    diContainer.register(CakeShopDetailUseCase.self) { resolver in
      CakeShopDetailUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    diContainer.register(CakeImagesByShopIdUseCase.self) { resolver in
      CakeImagesByShopIdUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    diContainer.register(CakeShopAdditionalInfoUseCase.self) { resolver in
      CakeShopAdditionalInfoUseCaseImpl(repository: resolver.resolve(CakeShopDetailRepository.self)!)
    }
    
    
    // Search Feature
    
    diContainer.register(MoyaProvider<SearchAPI>.self) { _ in
      #if STUB
      return MoyaProvider<SearchAPI>(stubClosure: { _ in .delayed(seconds: 1)}, plugins: [MoyaLoggingPlugin()])
      #else
      return MoyaProvider<SearchAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(SearchRepositoryImpl.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    diContainer.register(TrendingSearchKeywordUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return TrendingSearchKeywordUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchCakeImagesUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return SearchCakeImagesUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepositoryImpl.self)!
      return SearchCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchViewModel.self) { resolver in
      let trendingSearchKeywordUseCase = resolver.resolve(TrendingSearchKeywordUseCase.self)!
      let searchCakeImagesUseCase = resolver.resolve(SearchCakeImagesUseCase.self)!
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                             searchCakeImagesUseCase: searchCakeImagesUseCase,
                             searchCakeShopUseCase: searchCakeShopUseCase)
    }
    
    diContainer.register(SearchHistoryUseCase.self) { _ in
      return UserDefaultsSearchHistoryUseCase()
    }
    
    diContainer.register(SearchHistoryViewModel.self) { resolver in
      let searchHistoryUseCase = resolver.resolve(SearchHistoryUseCase.self)!
      return SearchHistoryViewModel(searchHistoryUseCase: searchHistoryUseCase)
    }
    
    diContainer.register(SearchRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<SearchAPI>.self)!
      return SearchRepositoryImpl(provider: provider)
    }
    
    diContainer.register(TrendingCakeShopsUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return TrendingCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(TrendingCakeShopViewModel.self) { resolver in
      TrendingCakeShopViewModel(useCase: resolver.resolve(TrendingCakeShopsUseCase.self)!)
    }
    
    diContainer.register(SearchCakeShopOnMapViewModel.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      let searchLocatedCakeShopUseCase = SearchLocatedCakeShopUseCaseImpl(repository: repository)
      return SearchCakeShopOnMapViewModel(useCase: searchLocatedCakeShopUseCase)
    }
    
    diContainer.register(SearchLocatedCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(SearchRepository.self)!
      return SearchLocatedCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(CakeShopNearByMeViewModel.self) { resolver in
      CakeShopNearByMeViewModel(useCase: resolver.resolve(SearchLocatedCakeShopUseCase.self)!)
    }
    
    diContainer.register(TrendingCakeImagesUseCase.self) { resolver in
      MockTrendingCakeImagesUseCase() // TODO: 네트워킹 구현체로 변경
    }
    
    diContainer.register(TrendingCakeImagesViewModel.self) { resolver in
      TrendingCakeImagesViewModel(useCase: resolver.resolve(TrendingCakeImagesUseCase.self)!)
    }
    
    // MARK: - Like
    
    diContainer.register(MoyaProvider<LikeAPI>.self) { _ in
      #if STUB
      MoyaProvider<LikeAPI>(stubClosure: { _ in .delayed(seconds: 0.2) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<LikeAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(LikeRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<LikeAPI>.self)!
      return LikeRepositoryImpl(provider: provider)
    }
    
    diContainer.register(LikeCakeShopUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeShopUseCaseImpl(repository: repository)
    }
    
    diContainer.register(LikeCakeImageUseCase.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      return LikeCakeImageUseCaseImpl(repository: repository)
    }
    
    diContainer.register(LikedItemsViewModel.self) { resolver in
      let repository = resolver.resolve(LikeRepository.self)!
      let likeCakeImageUseCase = LikeCakeImageUseCaseImpl(repository: repository)
      let likeCakeShopUseCase = LikeCakeShopUseCaseImpl(repository: repository)
      return LikedItemsViewModel(likeCakeImageUseCase: likeCakeImageUseCase,
                                 likeCakeShopUseCase: likeCakeShopUseCase)
    }
    
    diContainer.register(MoyaProvider<BusinessOwnerAPI>.self) { _ in
      #if STUB
      MoyaProvider<BusinessOwnerAPI>(stubClosure: { _ in .delayed(seconds: 0.2) }, plugins: [MoyaLoggingPlugin()])
      #else
      MoyaProvider<BusinessOwnerAPI>(plugins: [MoyaLoggingPlugin()])
      #endif
    }
    
    diContainer.register(BusinessOwnerRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<BusinessOwnerAPI>.self)!
      return BusinessOwnerRepositoryImpl(provider: provider)
    }
    
    diContainer.register(CakeShopOwnerVerificationUseCase.self) { resolver in
      let repository = resolver.resolve(BusinessOwnerRepository.self)!
      return CakeShopOwnerVerificationUseCaseImpl(repository: repository)
    }
    
    diContainer.register(SearchMyShopViewModel.self) { resolver in
      let searchCakeShopUseCase = resolver.resolve(SearchCakeShopUseCase.self)!
      return SearchMyShopViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
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

import PreviewSupportCakeShop // TODO: Networking 구현 완료되면 삭제할 것
import PreviewSupportSearch
