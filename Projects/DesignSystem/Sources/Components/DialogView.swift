//
//  DialogView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct DialogView: View {
  
  // MARK: - Properties
  
  private let title: String
  private let message: String
  
  private let primaryButtonTitle: String
  private let primaryButtonAction: () -> Void
  
  private let secondaryButtonTitle: String?
  private let secondaryButtonAction: (() -> Void)?
  
  
  // MARK: - Initializers
  
  public init(title: String, 
              message: String = "",
              primaryButtonTitle: String,
              primaryButtonAction: @escaping () -> Void,
              secondaryButtonTitle: String? = nil,
              secondaryButtonAction: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.primaryButtonTitle = primaryButtonTitle
    self.primaryButtonAction = primaryButtonAction
    self.secondaryButtonTitle = secondaryButtonTitle
    self.secondaryButtonAction = secondaryButtonAction
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack {
      VStack(spacing: 12) {
        Text(title)
          .font(.pretendard(size: 24, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(1)
        
        Text(message)
          .font(.pretendard(size: 15, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(4)
          .multilineTextAlignment(.leading)
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 8)
      
      HStack(spacing: 8) {
        if let secondaryButtonTitle,
           let secondaryButtonAction {
          Button {
            secondaryButtonAction()
          } label: {
            Rectangle()
              .fill(Color.white)
              .overlay {
                Text(secondaryButtonTitle)
                  .font(.pretendard(size: 15, weight: .bold))
                  .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
              }
              .frame(maxHeight: .infinity)
          }
          .modifier(BouncyPressEffect())
        }
        
        CKButtonRegular(title: primaryButtonTitle, action: {
          primaryButtonAction()
        })
      }
      .frame(height: 52)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 16)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .frame(width: 320)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.gray.opacity(0.2)
      .ignoresSafeArea()
    
    ScrollView {
      VStack {
        DialogView(title: "Title",
                   message: "message",
                   primaryButtonTitle: "Title",
                   primaryButtonAction: { },
                   secondaryButtonTitle: "Title",
                   secondaryButtonAction: { })
        
        DialogView(title: "Title",
                   message: "message",
                   primaryButtonTitle: "Title",
                   primaryButtonAction: { })
        
        DialogView(title: "Title",
                   message: "message\nmessage\nmessage\nmessage\nmessage",
                   primaryButtonTitle: "Title",
                   primaryButtonAction: { })
        
        DialogView(title: "Title",
                   message: "",
                   primaryButtonTitle: "Title",
                   primaryButtonAction: { })
      }
      .frame(maxWidth: .infinity)
    }
  }
}
