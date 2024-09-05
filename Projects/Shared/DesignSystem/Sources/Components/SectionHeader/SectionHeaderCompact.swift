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
  private let description: String?
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    icon: Image? = nil,
    description: String? = nil
  ) {
    self.title = title
    self.icon = icon
    self.description = description
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 4) {
      HStack(spacing: 8) {
        if let icon {
          icon
            .resizable()
            .frame(width: 14, height: 14)
        }
        
        Text(title)
          .font(.pretendard(size: 15, weight: .bold))
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(1)
      }
      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      
      if let description {
        Text(description)
          .font(.pretendard(size: 13))
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
          .lineLimit(2)
      }
    }
    .padding(.vertical, 9)
    .frame(minHeight: 44)
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
      
      SectionHeaderCompact(title: "title",
                           icon: Image(systemName: "info.circle.fill"),
                           description: "케이크샵의 소유주임을 인증할 수있는 사업자 등록증과 주민등록증을 첨부해 주세요.")
    }
  }
}
