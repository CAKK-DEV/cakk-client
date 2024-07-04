//
//  EditBusinessAccountSection.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import CommonUtil

import Router

struct EditBusinessAccountSection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: BusinessOwnerProfileViewModel
  
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "가게 정보")
        .padding(.horizontal, 24)
      
      listItem(title: "기본 정보 수정") {
        guard let cakeShopDetail = viewModel.cakeShopDetail else { return }
        router.navigate(to: PublicUserDestination.editShopBasicInfo(shopDetail: cakeShopDetail))
      }
      
      listItem(title: "가게 영업시간") {
        guard let cakeShopDetail = viewModel.cakeShopDetail,
              let cakeShopAdditionalInfo = viewModel.cakeShopAdditionalInfo else {
          return
        }
        router.navigate(to: PublicUserDestination.editWorkingDay(shopId: cakeShopDetail.shopId,
                                                                 workingDaysWithTime: cakeShopAdditionalInfo.workingDaysWithTime))
      }
      
      listItem(title: "가게 위치") {
        guard let cakeShopDetail = viewModel.cakeShopDetail,
              let cakeShopAdditionalInfo = viewModel.cakeShopAdditionalInfo else {
          return
        }
        router.navigate(to: PublicUserDestination.editLocation(shopId: cakeShopDetail.shopId,
                                                               cakeShopLocation: cakeShopAdditionalInfo.location))
      }
      
      listItem(title: "외부 링크") {
        guard let cakeShopDetail = viewModel.cakeShopDetail else { return }
        router.navigate(to: PublicUserDestination.editExternalLink(shopId: cakeShopDetail.shopId,
                                                                   externalLinks: cakeShopDetail.externalShopLinks))
      }
      
      listItem(title: "케이크 사진") {
        guard let cakeShopDetail = viewModel.cakeShopDetail else { return }
        router.navigate(to: PublicUserDestination.editCakeImages(shopId: cakeShopDetail.shopId))
      }
    }
    .padding(.vertical, 12)
  }
  
  private func listItem(title: String, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      Text(title)
    }
    .buttonStyle(ListItemButtonStyle())
  }
}


// MARK: - Preview

#Preview {
  EditBusinessAccountSection()
}
