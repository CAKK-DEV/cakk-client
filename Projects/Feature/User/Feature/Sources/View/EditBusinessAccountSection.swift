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
        navigator?.next(paths: ["edit_shop_basic_info"], items: ["shopId": shopId.description], isAnimated: true)
      }
      
      listItem(title: "가게 영업시간") {
        guard let shopId = viewModel.shopId else { return }
        navigator?.next(paths: ["edit_shop_working_day"], items: ["shopId": shopId.description], isAnimated: true)
      }
      
      listItem(title: "가게 위치") {
        guard let shopId = viewModel.shopId else { return }
        navigator?.next(paths: ["edit_shop_address"], items: ["shopId": shopId.description], isAnimated: true)
      }
      
      listItem(title: "외부 링크") {
        guard let shopId = viewModel.shopId else { return }
        navigator?.next(paths: ["edit_shop_external_link"], items: ["shopId": shopId.description], isAnimated: true)
      }
      
      listItem(title: "케이크 사진") {
        guard let shopId = viewModel.shopId else { return }
        navigator?.next(paths: ["edit_shop_image"], items: ["shopId": shopId.description], isAnimated: true)
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
