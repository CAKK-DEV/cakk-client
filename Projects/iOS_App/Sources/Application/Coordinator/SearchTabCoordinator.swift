//
//  SearchTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router
import CommonUtil

import FeatureSearch
import FeatureCakeShop
import FeatureUser

struct SearchTabCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject private var router = Router()
  private let viewModelRegistry = ViewModelRegistry()
  
  
  // MARK: - Internal Methods
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      SearchCoordinator()
        .sheet(item: $router.presentedSheet) { sheet in
          if let destination = sheet.destination as? PublicSearchSheetDestination {
            switch destination {
              // 케이크 이미지 간단 보기
            case .quickInfo(let imageId, let cakeImageUrl, let shopId):
              let _ = viewModelRegistry.registerCakeShopQuickInfoViewModel(imageId: imageId, cakeImageUrl: cakeImageUrl, shopId: shopId)
              CakeShopQuickInfoView()
                .environmentObject(router)
            }
          }
        }
        .navigationDestination(for: PublicSearchDestination.self) { destination in
          switch destination {
            // 케이크샵 디테일
          case .shopDetail(let shopId):
            let _ = viewModelRegistry.registerCakeShopDetailViewModel(shopId: shopId)
            CakeShopDetailCoordinator()
              .navigationDestination(for: PublicCakeShopDestination.self) { destination in
                // 사장님 인증
                if case .businessCertification(targetShopId: let targetShopId) = destination {
                  let _ = viewModelRegistry.registerBusinessCertificationViewModel(shopId: targetShopId)
                  BusinessCertificationView()
                    .toolbar(.hidden, for: .navigationBar)
                    .environmentObject(router)
                }
              }
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        }
        .navigationDestination(for: CakeShopDestination.self, destination: { destination in
          // 케이크샵 디테일
          if case .shopDetail(let shopId) = destination {
            let _ = viewModelRegistry.registerCakeShopDetailViewModel(shopId: shopId)
            CakeShopDetailCoordinator()
              .navigationDestination(for: PublicCakeShopDestination.self) { destination in
                // 사장님 인증
                if case .businessCertification(targetShopId: let targetShopId) = destination {
                  let _ = viewModelRegistry.registerBusinessCertificationViewModel(shopId: targetShopId)
                  BusinessCertificationView()
                    .toolbar(.hidden, for: .navigationBar)
                    .environmentObject(router)
                }
              }
              .navigationBarBackButtonHidden()
              .environmentObject(router)
          }
        })
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  SearchTabCoordinator()
}
