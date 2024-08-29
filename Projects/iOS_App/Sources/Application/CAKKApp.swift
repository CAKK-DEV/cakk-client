//
//  CAKKApp.swift
//  CAKK
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil

import FirebaseCore

import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

import DIContainer
import Swinject

import UserSession

import AnalyticsService

import LinkNavigator

import FeatureCakeShop

@main
struct CAKKApp: App {
  
  // MARK: - Properties
  
  @UIApplicationDelegateAdaptor var delegate: AppDelegate
  @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
  
  private var initialPath = [String]()
  private var navigator: LinkNavigator {
    delegate.navigator
  }
  
  private let deepLinkHandler = DeepLinkHandler()
  
  
  // MARK: - Initializers
  
  init() {
    initFirebase()
    initKakaoSDK()
    setupDIContainer()
    setupAnalytics()
    loadRocketSimConnect()
    
    UserSession.shared.initialize()
    
    if hasSeenOnboarding {
      initialPath = [RouteHelper.TabRoot.path]
    } else {
      initialPath = [RouteHelper.Onboarding.path]
    }
  }
  
  // MARK: - Internal
  
  var body: some Scene {
    WindowGroup {
      navigator
        .launch(paths: initialPath, items: [:])
        .ignoresSafeArea(.all)
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
          
          // URLScheme 기반 딥링크 처리
          if let deepLink = DeepLink(url: url) {
            deepLinkHandler.handle(deepLink: deepLink)
          }
        }
    }
  }
  
  
  // MARK: - Private
  
  private func setupDIContainer() {
    let assembler = Assembler([
      ImageUploaderAssembly(),
      FeatureCakeShopAssembly(),
      FeatureSearchAssembly(),
      FeatureUserAssembly(),
      FeatureLikeAssembly(),
      FeatureBusinessOwnerAssembly()
    ])
    DIContainer.shared.container = assembler.resolver as! Container
    
    DIContainer.shared.container.register(LinkNavigatorType.self) { _ in
      return delegate.navigator
    }
  }
  
  private func initKakaoSDK() {
    if let appKey = Bundle.main.infoDictionary?["KAKAO_SDK_APP_KEY"] as? String {
      KakaoSDK.initSDK(appKey: appKey)
    } else {
      assertionFailure("🔑 유효호지 않은 카카오 APP key 입니다.")
    }
  }
  
  private func initFirebase() {
    FirebaseApp.configure()
  }
  
  private func setupAnalytics() {
    DIContainer.shared.container.register(AnalyticsService.self) { _ in
      AnalyticsServiceImpl()
    }
  }
  
   private func loadRocketSimConnect() {
     #if DEBUG
     guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
       print("Failed to load linker framework")
       return
     }
     print("RocketSim Connect successfully linked")
     #endif
   }
}
