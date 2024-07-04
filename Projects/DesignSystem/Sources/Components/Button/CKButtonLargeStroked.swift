//
//  CKButtonLargeStroked.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKButtonLargeStroked: View {
  
  // MARK: - Properties
  
  private let title: String
  private let action: (() -> Void)?
  private let fixedSize: CGFloat?
  @Binding var isLoading: Bool
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    fixedSize: CGFloat? = nil,
    action: (() -> Void)? = nil,
    isLoading: Binding<Bool>? = nil
  ) {
    self.title = title
    self.action = action
    self.fixedSize = fixedSize
    _isLoading = isLoading ?? .constant(false)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Button {
      action?()
    } label: {
      Text(title)
        .font(.pretendard(size: 20, weight: .bold))
        .foregroundStyle(Color.white)
        .padding(.horizontal, 20)
        .frame(height: 64)
        .frame(maxWidth: fixedSize == .infinity ? .infinity : nil)
        .lineLimit(1)
        .opacity(isLoading ? 0 : 1.0)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .fill(DesignSystemAsset.black.swiftUIColor)
            .overlay {
              RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.24), lineWidth: 2)
                .padding(1)
            }
            .frame(maxWidth: fixedSize)
        }
        .frame(maxWidth: fixedSize)
        .overlay {
          if isLoading {
            ProgressView()
              .tint(.white)
          }
        }
    }
    .modifier(BouncyPressEffect())
  }
}

// MARK: - Preview

#Preview {
  VStack {
    CKButtonLargeStroked(title: "Self sizing")
    CKButtonLargeStroked(title: "Fixed size", fixedSize: 200)
    CKButtonLargeStroked(title: "Infinity size", fixedSize: .infinity)
    CKButtonLargeStroked(title: "Self sizing", isLoading: .constant(true))
  }
}
