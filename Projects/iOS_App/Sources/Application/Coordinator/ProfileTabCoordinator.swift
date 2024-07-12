//
//  ProfileTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import FeatureUser
import FeatureCakeShopAdmin

struct ProfileTabCoordinator: View {
  
  // MARK: - Properties
  
  @StateObject private var router = Router()
  private let viewModelRegistry = ViewModelRegistry()
  
  
  // MARK: - Views
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      UserCoordinator()
        .navigationDestination(for: PublicUserDestination.self) { destination in
          switch destination {
            // 케이크샵 이미지 수정
          case .editCakeImages(let shopId):
            let _ = viewModelRegistry.registerEditCakeShopImagesViewModel(shopId: shopId)
            EditCakeImagesCoordinator()
              .environmentObject(router)
            
            // 가게 외부 링크 수정
          case .editExternalLink(let shopId, let externalLinks):
            let _ = viewModelRegistry.registerEditExternalLinkViewModel(shopId: shopId, externalLinks: externalLinks)
            EditExternalLinkView()
              .environmentObject(router)
            
            // 가게 위치 수정
          case .editLocation(let shopId, let cakeShopLocation):
            let _ = viewModelRegistry.registerEditCakeShopAddressViewModel(shopId: shopId, cakeShopLocation: cakeShopLocation)
            EditCakeShopAddressView()
              .environmentObject(router)
            
            // 가게 기본정보 수정
          case .editShopBasicInfo(let shopDetail):
            let _ = viewModelRegistry.registerEditCakeShopBasicInfoViewModel(shopDetail: shopDetail)
            EditCakeShopBasicInfoView()
              .environmentObject(router)
            
            // 영업일 수정
          case .editWorkingDay(let shopId, let workingDaysWithTime):
            let _ = viewModelRegistry.registerEditWorkingDayViewModel(shopId: shopId, workingDaysWithTime: workingDaysWithTime)
            EditWorkingDayView()
              .environmentObject(router)
            
          default:
            EmptyView()
          }
        }
    }
    .environmentObject(router)
  }
}


// MARK: - Preview

#Preview {
  ProfileTabCoordinator()
}
