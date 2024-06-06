//
//  CKButtonRegular.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKButtonRegular: View {
  
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
        .padding(.horizontal, 20)
        .frame(height: 52)
        .frame(maxWidth: fixedSize == .infinity ? .infinity : nil)
        .lineLimit(1)
        .background {
          RoundedRectangle(cornerRadius: 14)
            .fill(DesignSystemAsset.black.swiftUIColor)
            .frame(width: fixedSize)
        }
    }
    .modifier(BouncyPressEffect())
  }
}

// MARK: - Preview

#Preview {
  VStack {
    CKButtonRegular(title: "Self sizing")
    CKButtonRegular(title: "Fixed size", fixedSize: 200)
    CKButtonRegular(title: "Infinity size", fixedSize: .infinity)
  }
}
