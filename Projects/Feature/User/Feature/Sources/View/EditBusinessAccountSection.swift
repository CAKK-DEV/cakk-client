//
//  EditBusinessAccountSection.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import SwiftUIUtil

import Router

struct EditBusinessAccountSection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "가게 정보")
        .padding(.horizontal, 24)
      
      listItem(title: "기본 정보 수정") {
        router.navigate(to: PublicUserDestination.editShopProfile)
      }
      
      listItem(title: "가게 영업시간") {
        router.navigate(to: PublicUserDestination.editWorkingDay)
      }
      
      listItem(title: "가게 위치") {
        router.navigate(to: PublicUserDestination.editLocation)
      }
      
      listItem(title: "외부 링크") {
        router.navigate(to: PublicUserDestination.editExternalLink)
      }
      
      listItem(title: "케이크 사진") {
        router.navigate(to: PublicUserDestination.editCakeImage)
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
