//
//  CakeShopHomeView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import CommonUtil
import Logger
import DIContainer

import AppTrackingTransparency

import AnalyticsService

struct CakeShopHomeView: View {
  
  // MARK: - Properties
  
  @StateObject var tabDoubleTapObserver = TabDoubleTapObserver(.doubleTapCakeShopTab)
  
  private var analytics: AnalyticsService?
  
  
  // MARK: - Properties
  
  public init() {
    let diContainer = DIContainer.shared.container
    self.analytics = diContainer.resolve(AnalyticsService.self)
  }

  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        size: .large,
        leadingContent: {
          DesignSystemAsset.logo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 30)
        })
      
      ScrollViewReader { scrollProxy in
        ScrollView {
          VStack(spacing: 44) {
            CakeCategorySection()
              .id("first_section")
            
            TrendingCakeShopSection()
            
            CakeShopsNearByMeSection()
            
            TrendingCakeImageSection()
          }
          .padding(.vertical, 16)
        }
        .onChange(of: tabDoubleTapObserver.doubleTabActivated) { _ in
          withAnimation {
            scrollProxy.scrollTo("first_section")
          }
        }
      }
    }
    .onFirstAppear {
      requestIDFAPermission()
    }
    .onAppear {
      analytics?.logEngagement(view: self)
    }
  }
  
  
  // MARK: - Private Methods
  
  private func requestIDFAPermission() {
    ATTrackingManager.requestTrackingAuthorization { status in
      /// status를 가지고 필요한 작업이 있다면 합니다.
      Loggers.featureCakeShop.info("앱 추적 권한 \(status)", category: .auth)
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop
import PreviewSupportSearch

#Preview {
  let diConatiner = DIContainer.shared.container
  diConatiner.register(TrendingCakeShopViewModel.self) { _ in
    let mockUseCase = MockTrendingCakeShopsUseCase()
    return .init(useCase: mockUseCase)
  }
  
  diConatiner.register(CakeShopNearByMeViewModel.self) { _ in
    let mockUseCase = MockSearchLocatedCakeShopUseCase()
    return .init(useCase: mockUseCase)
  }
  
  diConatiner.register(TrendingCakeImagesViewModel.self) { _ in
    let mockUseCase = MockTrendingCakeImagesUseCase()
    return .init(useCase: mockUseCase)
  }
  
  return CakeShopHomeView()
}
