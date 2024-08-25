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

import LinkNavigator
import DIContainer

struct EditBusinessAccountSection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var viewModel: BusinessOwnerProfileViewModel
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init() {
    let container = DIContainer.shared.container
    self.navigator = container.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "가게 정보")
        .padding(.horizontal, 24)
      
      listItem(title: "기본 정보 수정") {
        guard let shopId = viewModel.shopId else { return }
        let items = RouteHelper.EditShopBasicInfo.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.EditShopBasicInfo.path], items: items, isAnimated: true)
      }
      
      listItem(title: "가게 영업시간") {
        guard let shopId = viewModel.shopId else { return }
        let items = RouteHelper.EditShopWorkingDay.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.EditShopWorkingDay.path], items: items, isAnimated: true)
      }
      
      listItem(title: "가게 위치") {
        guard let shopId = viewModel.shopId else { return }
        let items = RouteHelper.EditShopAddress.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.EditShopAddress.path], items: items, isAnimated: true)
      }
      
      listItem(title: "외부 링크") {
        guard let shopId = viewModel.shopId else { return }
        let items = RouteHelper.EditExternalLink.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.EditExternalLink.path], items: items, isAnimated: true)
      }
      
      listItem(title: "케이크 사진") {
        guard let shopId = viewModel.shopId else { return }
        let items = RouteHelper.EditShopImage.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.EditShopImage.path], items: items, isAnimated: true)
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
