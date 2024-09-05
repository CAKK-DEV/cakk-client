//
//  SectionHeaderLarge.swift
//  DesignSystem
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct SectionHeaderLarge: View {
  
  // MARK: - Properties
  
  private let title: String
  private let description: String?
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    description: String? = nil
  ) {
    self.title = title
    self.description = description
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.pretendard(size: 20, weight: .bold))
        .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
      
      if let description {
        Text(description)
          .font(.pretendard(size: 13, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(1)
      }
    }
    .padding(.vertical, 14)
    .background(Color.white)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    VStack {
      SectionHeaderLarge(title: "title")
      SectionHeaderLarge(title: "title", description: "description description")
    }
  }
}
