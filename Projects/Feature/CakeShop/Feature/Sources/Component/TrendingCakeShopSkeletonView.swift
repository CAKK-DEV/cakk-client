//
//  TrendingCakeShopSkeletonView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

struct TrendingCakeShopSkeletonView: View {
  var body: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        Circle()
          .fill(DesignSystemAsset.gray10.swiftUIColor)
          .size(52)
        
        VStack(alignment: .leading, spacing: 8) {
          RoundedRectangle(cornerRadius: 6)
            .fill(DesignSystemAsset.gray10.swiftUIColor)
            .frame(width: 120, height: 18)
          
          VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 4)
              .fill(DesignSystemAsset.gray10.swiftUIColor)
              .frame(width: 144, height: 14)
          }
        }
        
        Spacer()
      }
      
      VStack {
        HStack {
          DesignSystemAsset.gray10.swiftUIColor
            .size(152)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.topLeft])
          
          VStack {
            DesignSystemAsset.gray10.swiftUIColor
              .size(72)
              .roundedCorner(8, corners: .allCorners)
              .roundedCorner(12, corners: [.topRight])
            
            DesignSystemAsset.gray10.swiftUIColor
              .size(72)
              .roundedCorner(8, corners: .allCorners)
          }
        }
        
        HStack {
          DesignSystemAsset.gray10.swiftUIColor
            .size(72)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.bottomLeft])
          
          DesignSystemAsset.gray10.swiftUIColor
            .size(72)
            .roundedCorner(8, corners: .allCorners)
          
          DesignSystemAsset.gray10.swiftUIColor
            .size(72)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.bottomRight])
        }
      }
      .frame(maxWidth: .infinity)
    }
    .padding(16)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
    }
    .frame(maxWidth: 264)
    
  }
}


// MARK: - Preview

#Preview {
  TrendingCakeShopSkeletonView()
}
