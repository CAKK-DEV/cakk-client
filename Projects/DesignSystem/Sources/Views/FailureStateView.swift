//
//  FailureStateView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/3/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct FailureStateView: View {
  
  // MARK: - Properties
  
  private let title: String
  private let buttonTitle: String?
  private let buttonAction: (() -> Void)?
  private let buttonDescription: String?
  
  
  // MARK: - Initializers
  
  public init(title: String,
       buttonTitle: String? = nil,
       buttonAction: (() -> Void)? = nil,
       buttonDescription: String? = nil) {
    self.title = title
    self.buttonTitle = buttonTitle
    self.buttonAction = buttonAction
    self.buttonDescription = buttonDescription
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 28) {
      VStack(spacing: 24) {
        DesignSystemAsset.cakeCrying.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100)

        Text(title)
          .font(.pretendard(size: 15, weight: .bold))
          .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
      }
      
      VStack(spacing: 12) {
        if let buttonTitle {
          CKButtonCompact(title: buttonTitle) {
            buttonAction?()
          }
        }
        
        if let buttonDescription {
          Text(buttonDescription)
            .font(.pretendard(size: 13, weight: .medium))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .multilineTextAlignment(.center)
        }
      }
    }
  }
}


// MARK: - Preview

#Preview {
  VStack {
    FailureStateView(title: "Title")
    
    FailureStateView(
      title: "Title",
      buttonTitle: "Button title",
      buttonDescription: "button description")
  }
}
