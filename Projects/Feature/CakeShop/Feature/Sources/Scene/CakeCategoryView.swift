//
//  CakeCategoryView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import Kingfisher

import Router

import CommonDomain

struct CakeCategoryView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @State private var category: CakeCategory
  
  
  // MARK: - Initializers
  
  init(category: CakeCategory) {
    self.category = category
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      CategorySelectionNavigationView(selection: $category)
      
      TabView(selection: $category) {
        ForEach(CakeCategory.allCases, id: \.self) { cakeCategory in
          CakeCategoryImageListView(category: cakeCategory)
            .tag(cakeCategory)
        }
      }

      .tabViewStyle(.page(indexDisplayMode: .never))
      .ignoresSafeArea()
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop
import PreviewSupportSearch

#Preview {
  CakeCategoryView(category: .character)
}
