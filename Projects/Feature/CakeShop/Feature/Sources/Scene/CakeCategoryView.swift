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

import CommonDomain

import DIContainer
import AnalyticsService

struct CakeCategoryView: View {
  
  // MARK: - Properties
  
  @State private var category: CakeCategory
  
  private let analytics: AnalyticsService?
  
  
  // MARK: - Initializers
  
  init(category: CakeCategory) {
    self.category = category
    
    let diContainer = DIContainer.shared.container
    self.analytics = diContainer.resolve(AnalyticsService.self)
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
    .onAppear {
      analytics?.logEngagement(view: self, parameters: ["category": category.displayName])
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop
import PreviewSupportSearch

#Preview {
  CakeCategoryView(category: .character)
}
