//
//  SectionHeaderCompact.swift
//  DesignSystem
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct SectionHeaderCompact: View {
  
  // MARK: - Properties
  
  private let title: String
  private let icon: Image?
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    icon: Image? = nil
  ) {
    self.title = title
    self.icon = icon
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    HStack(spacing: 8) {
      if let icon {
        icon
          .resizable()
          .frame(width: 14, height: 14)
      }
      
      Text(title)
        .font(.pretendard(size: 15, weight: .bold))
        .frame(height: 44)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
    }
    .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
    .background(Color.white)
      
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    VStack {
      SectionHeaderCompact(title: "title")
      SectionHeaderCompact(title: "title", icon: Image(systemName: "info.circle.fill"))
    }
  }
}
