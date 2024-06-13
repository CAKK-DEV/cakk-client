//
//  NavigationBar.swift
//  DesignSystem
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct NavigationBar<LeadingContent, CenterContent, TrailingContent>: View where LeadingContent: View, CenterContent: View, TrailingContent: View {
  
  // MARK: - Properties
  
  private let leadingContent: () -> LeadingContent?
  private let centerContent: () -> CenterContent?
  private let trailingContent: () -> TrailingContent?
  private let isDividerShown: Bool
  
  
  // MARK: - Initializers
  
  public init(
    isDividerShown: Bool = true,
    @ViewBuilder leadingContent: @escaping () -> LeadingContent? = { EmptyView() },
    @ViewBuilder centerContent: @escaping () -> CenterContent? = { EmptyView() },
    @ViewBuilder trailingContent: @escaping () -> TrailingContent? = { EmptyView() }
  ) {
    self.isDividerShown = isDividerShown
    self.leadingContent = leadingContent
    self.centerContent = centerContent
    self.trailingContent = trailingContent
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack{
        Spacer()
          .overlay {
            HStack {
              leadingContent()
              Spacer()
            }
          }
        
        centerContent()
        
        Spacer()
          .overlay {
            HStack {
              Spacer()
              trailingContent()
            }
          }
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, minHeight: 52)
      .background(Color.white)
      
      Rectangle()
        .fill(DesignSystemAsset.gray20.swiftUIColor)
        .frame(maxWidth: .infinity, maxHeight: 1)
        .opacity(isDividerShown ? 1.0 : 0.0)
    }
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
   
    VStack {
      NavigationBar(leadingContent: {
        Button("", systemImage: "arrow.left") {
          // no action
        }
      }, centerContent: {
        Text("Title")
      }, trailingContent: {
        Button("", systemImage: "arrow.right") {
          // no action
        }
      })
      
      NavigationBar(leadingContent: {
        Button("", systemImage: "arrow.left") {
          // no action
        }
      }, centerContent: {
        Text("Title")
      })
      
      NavigationBar(centerContent: {
        Text("Title")
      })
    }
  }
}
