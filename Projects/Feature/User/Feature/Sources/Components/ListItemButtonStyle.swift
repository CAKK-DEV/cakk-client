//
//  ListItemButtonStyle.swift
//  FeatureUser
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ListItemButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .font(.pretendard(size: 15, weight: .medium))
      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 28)
      .background(Color.white)
      .frame(height: 52)
  }
}
