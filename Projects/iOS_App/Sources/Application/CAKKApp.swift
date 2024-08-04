//
//  CAKKApp.swift
//  CAKK
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FirebaseCore

import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

import DIContainer
import Swinject

@main
struct CAKKApp: App {
  
  // MARK: - Properties
  
  @UIApplicationDelegateAdaptor var delegate: AppDelegate
  
  
  // MARK: - Initializers
  
  init() {
    FirebaseApp.configure()
    initKakaoSDK()
    setupDIContainer()
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
    let assembler = Assembler([
      ImageUploaderAssembly(),
      FeatureCakeShopAssembly(),
      FeatureSearchAssembly(),
      FeatureUserAssembly(),
      FeatureLikeAssembly(),
      FeatureBusinessOwnerAssembly()
    ])
    DIContainer.shared.container = assembler.resolver as! Container
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
}
