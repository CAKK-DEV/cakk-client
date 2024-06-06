//
//  SectionHeader.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

struct SectionHeader: View {
  
  // MARK: - Properties
  
  private let title: String
  
  
  // MARK: - Initializers
  
  init(title: String) {
    self.title = title
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      Text(title)
        .font(.pretendard(size: 20, weight: .bold))
        .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 16)
    .frame(height: 52)
    .background(Color.white)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    SectionHeader(title: "title")
  }
}
