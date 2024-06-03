//
//  MainNavigationView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

struct MainNavigationView: View {
  
  // MARK: - Views
  
  var body: some View {
    HStack(spacing: 0) {
      DesignSystemAsset.logo.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 30)
      
      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, minHeight: 64)
    .background(Color.white)
    .overlay {
      VStack(spacing: 0) {
        Spacer()
        Rectangle()
          .fill(DesignSystemAsset.gray20.swiftUIColor)
          .frame(height: 1)
      }
    }
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    MainNavigationView()
  }
}
