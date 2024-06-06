//
//  CKTextField.swift
//  DesignSystem
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct CKTextField: View {
  
  // MARK: - Properties
  
  @Binding public var text: String
  private let placeholder: String
  private let headerTitle: String?
  private let supportsMultiline: Bool
  private let isDisabled: Bool
  
  
  // MARK: - Initializers
  
  public init(
    text: Binding<String>,
    placeholder: String = "",
    headerTitle: String? = nil,
    supportsMultiline: Bool = false,
    isDisabled: Bool = false
  ) {
    _text = text
    self.placeholder = placeholder
    self.headerTitle = headerTitle
    self.supportsMultiline = supportsMultiline
    self.isDisabled = isDisabled
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 8) {
      if let headerTitle {
        SectionHeaderCompact(title: headerTitle)
      }
      
      TextField(placeholder, text: $text, axis: supportsMultiline ? .vertical : .horizontal)
        .font(.pretendard(size: 15, weight: .medium))
        .foregroundStyle(isDisabled ? DesignSystemAsset.gray40.swiftUIColor : DesignSystemAsset.black.swiftUIColor)
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
        .background {
          RoundedRectangle(cornerRadius: 14)
            .fill(DesignSystemAsset.gray10.swiftUIColor)
        }
        .disabled(isDisabled)
    }
  }
}


// MARK: - Preview

private struct Preview_Content: View {
  
  @State private var text = ""
  
  var body: some View {
    VStack {
      CKTextField(text: $text, placeholder: "placeholder", headerTitle: "title")
      CKTextField(text: $text, placeholder: "placeholder", headerTitle: "title", supportsMultiline: true)
      CKTextField(text: $text, placeholder: "placeholder", headerTitle: "title", isDisabled: true)
    }
    .padding()
  }
}

#Preview {
  Preview_Content()
}
