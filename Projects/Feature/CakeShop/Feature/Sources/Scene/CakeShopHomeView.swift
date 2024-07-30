//
//  CakeShopHomeView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import Logger

import DIContainer

import AppTrackingTransparency

struct CakeShopHomeView: View {
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
      
      ScrollView {
        VStack(spacing: 44) {
          CakeCategorySection()
          
          TrendingCakeShopSection()
          
          CakeShopsNearByMeSection()
          
          TrendingCakeImageSection()
        }
        .padding(.vertical, 16)
      }
    }
    .onFirstAppear {
      requestIDFAPermission()
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
