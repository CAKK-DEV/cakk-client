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
  
  
  // MARK: - Initializers
  
  public init(title: String) {
    self.title = title
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Text(title)
      .font(.pretendard(size: 15, weight: .bold))
      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      .frame(height: 44)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}


// MARK: - Preview

#Preview {
  SectionHeaderCompact(title: "title")
}
