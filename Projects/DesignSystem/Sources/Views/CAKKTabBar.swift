//
//  CAKKTabBar.swift
//  DesignSystem
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil

public struct CAKKTabBar: View {
  
  // MARK: - Properties
  
  @Binding private var selectedTab: Tab
  public enum Tab {
    case cakeShop
    case search
    case liked
    case profile
  }
  
  
  // MARK: - Initializers
  
  public init(selectedTab: Binding<Tab>) {
    _selectedTab = selectedTab
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      Divider()
        .overlay {
          DesignSystemAsset.gray20.swiftUIColor
        }
      
      HStack {
        Spacer()
        
        Button() {
          selectedTab = .cakeShop
        } label: {
          DesignSystemAsset.cakeSlice.swiftUIImage
            .resizable()
            .size(24)
            .foregroundStyle(selectedTab == .cakeShop
                             ? DesignSystemAsset.black.swiftUIColor
                             : DesignSystemAsset.gray40.swiftUIColor)
        }
        .modifier(BouncyPressEffect())
        
        Spacer()
        
        Button {
          selectedTab = .search
        } label: {
          DesignSystemAsset.magnifyingGlass.swiftUIImage
            .resizable()
            .size(24)
            .foregroundStyle(selectedTab == .search
                             ? DesignSystemAsset.black.swiftUIColor
                             : DesignSystemAsset.gray40.swiftUIColor)
        }
        .modifier(BouncyPressEffect())
        
        Spacer()
        
        Button {
          selectedTab = .liked
        } label: {
          Image(systemName: "heart.fill")
            .font(.system(size: 24))
            .foregroundStyle(selectedTab == .liked
                             ? DesignSystemAsset.black.swiftUIColor
                             : DesignSystemAsset.gray40.swiftUIColor)
        }
        .modifier(BouncyPressEffect())
        
        Spacer()
        
        Button {
          selectedTab = .profile
        } label: {
          DesignSystemAsset.person.swiftUIImage
            .resizable()
            .size(24)
            .foregroundStyle(selectedTab == .profile
                             ? DesignSystemAsset.black.swiftUIColor
                             : DesignSystemAsset.gray40.swiftUIColor)
        }
        .modifier(BouncyPressEffect())
        
        Spacer()
      }
      .frame(height: 56)
    }
    .background(Color.white.ignoresSafeArea())
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    VStack {
      CAKKTabBar(selectedTab: .constant(.cakeShop))
      CAKKTabBar(selectedTab: .constant(.search))
      CAKKTabBar(selectedTab: .constant(.liked))
      CAKKTabBar(selectedTab: .constant(.profile))
    }
  }
}
