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
  
  
  // MARK: - Initializers
  
  public init(title: String,
              message: String,
              action: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.action = action
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Button {
      action?()
    } label: {
      RoundedRectangle(cornerRadius: 20)
        .fill(DesignSystemAsset.black.swiftUIColor)
        .overlay {
          VStack(spacing: 5) {
            Text(title)
              .font(.pretendard(size: 17, weight: .bold))
              .frame(maxWidth: .infinity)
              .lineLimit(1)
            
            Text(message)
              .font(.pretendard(size: 12, weight: .medium))
              .frame(maxWidth: .infinity)
              .lineLimit(1)
          }
          .foregroundStyle(Color.white)
        }
        .frame(minWidth: 40, maxHeight: 64)
    }
    .modifier(BouncyPressEffect())
  }
}

// MARK: - Preview

#Preview {
  CKButtonLargeMessage(title: "Title", message: "message")
}
