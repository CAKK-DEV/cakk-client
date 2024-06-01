//
//  CKButtonLarge.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKButtonLarge: View {
  
  // MARK: - Properties
  
  private let title: String
  private let action: (() -> Void)?
  
  
  // MARK: - Initializers
  
  public init(title: String,
              action: (() -> Void)? = nil) {
    self.title = title
    self.action = action
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Button {
      action?()
    } label: {
      RoundedRectangle(cornerRadius: 20)
        .fill(DesignSystemAsset.black.swiftUIColor)
        .frame(minWidth: 40, maxHeight: 64)
        .overlay {
          Text(title)
            .font(.pretendard(size: 20, weight: .bold))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .lineLimit(1)
        }
    }
    .modifier(BouncyPressEffect())
  }
}

// MARK: - Preview

#Preview {
  CKButtonLarge(title: "Title")
}
