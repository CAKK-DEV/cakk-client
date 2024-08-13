//
//  CakeShopTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import FeatureCakeShop
import FeatureCakeShopAdmin
import FeatureSearch
import FeatureCakeShop
import FeatureUser

struct CakeShopTabCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject private var router = Router()
  private let viewModelRegistry = ViewModelRegistry()
  

  // MARK: - Internal Methods
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopCoordinator()
        .navigationDestination(for: PublicCakeShopDestination.self) { destination in
          switch destination {
            // 지도
          case .map:
            SearchCakeShopOnMapView()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
            
            // 사장님 인증
          case .businessCertification(targetShopId: let targetShopId):
            let _ = viewModelRegistry.registerBusinessCertificationViewModel(shopId: targetShopId)
            BusinessCertificationView()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
            
            // 외부링크 수정
          case .editExternalLink(let shopId, let externalLinks):
            let _ = viewModelRegistry.registerEditExternalLinkViewModel(shopId: shopId, externalLinks: externalLinks)
            EditExternalLinkView()
              .environmentObject(router)
          }
        }
        .navigationDestination(for: PublicSearchDestination.self) { destination in
          switch destination {
            // 케이크샵 상세
          case .shopDetail(let shopId):
            let _ = viewModelRegistry.registerCakeShopDetailViewModel(shopId: shopId)
            CakeShopDetailCoordinator()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
          }
        }
        .fullScreenCover(item: $router.presentedFullScreenSheet) { destination in
          if let destination = destination.destination as? PublicCakeShopSheetDestination {
            switch destination {
              // 로그인
            case .login:
              let _ = viewModelRegistry.registerSocialLoginViewModel()
              let _ = viewModelRegistry.registerEmailVerificationViewModel()
              LoginStepCoordinator(onFinish: {
                router.presentedFullScreenSheet = nil
              })
              .environmentObject(router)
            }
          }
        }
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  CakeShopTabCoordinator()
}
