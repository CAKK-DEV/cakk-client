//
//  CKButtonLargeMessage.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKButtonLargeMessage: View {
  
  // MARK: - Properties
  
  private let title: String
  private let message: String
  private let action: (() -> Void)?
  private let fixedSize: CGFloat?
  
  
  // MARK: - Initializers
  
  public init(title: String,
              message: String,
              fixedSize: CGFloat? = nil,
              action: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.action = action
    self.fixedSize = fixedSize
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Button {
      action?()
    } label: {
      VStack(spacing: 5) {
        Text(title)
          .font(.pretendard(size: 17, weight: .bold))
          .lineLimit(1)
          .frame(maxWidth: fixedSize == .infinity ? .infinity : nil)
        
        Text(message)
          .font(.pretendard(size: 12, weight: .medium))
          .lineLimit(1)
          .frame(maxWidth: fixedSize == .infinity ? .infinity : nil)
      }
      .padding(.horizontal, 20)
      .foregroundStyle(Color.white)
      .frame(height: 64)
      .background {
        RoundedRectangle(cornerRadius: 20)
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
    CKButtonLargeMessage(title: "Title", message: "self sizing")
    CKButtonLargeMessage(title: "Title", message: "fixed size", fixedSize: 200)
    CKButtonLargeMessage(title: "Title", message: "Infinity size", fixedSize: .infinity)
  }
}
