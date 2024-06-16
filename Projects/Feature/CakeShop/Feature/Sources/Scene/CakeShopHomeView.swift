//
//  CakeShopHomeView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

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
        }
        .padding(.vertical, 16)
      }
    }
  }
}

#Preview {
  CakeShopHomeView()
}
