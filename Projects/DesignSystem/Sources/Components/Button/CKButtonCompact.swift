//
//  CKButtonCompact.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKButtonCompact: View {
  
  // MARK: - Properties
  
  private let title: String
  private let action: (() -> Void)?
  private let fixedSize: CGFloat?
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    fixedSize: CGFloat? = nil,
    action: (() -> Void)? = nil)
  {
    self.title = title
    self.action = action
    self.fixedSize = fixedSize
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Button {
      action?()
    } label: {
      Text(title)
        .font(.pretendard(size: 15, weight: .bold))
        .foregroundStyle(Color.white)
        .lineLimit(1)
        .padding(.horizontal, 20)
        .frame(height: 48)
        .frame(maxWidth: fixedSize == .infinity ? .infinity : nil)
        .background {
          RoundedRectangle(cornerRadius: 14)
            .fill(DesignSystemAsset.black.swiftUIColor)
            .frame(minWidth: 40)
            .frame(width: fixedSize)
        }
        .frame(width: fixedSize)
    }
    .modifier(BouncyPressEffect())
  }
}

// MARK: - Preview

#Preview {
  VStack {
    CKButtonCompact(title: "Self sizing")
    CKButtonCompact(title: "Fixed size", fixedSize: 200)
    CKButtonCompact(title: "Infinity size", fixedSize: .infinity)
  }
}
