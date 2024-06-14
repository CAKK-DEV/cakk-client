//
//  AppTabView.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import FeatureUser
import FeatureOnboarding
import FeatureCakeShop

struct AppTabView: View {
  
  // MARK: - Properties
  
  @State private var selectedTab: CAKKTabBar.Tab = .cakeShop
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $selectedTab) {
        CakeShopTabCoordinator()
          .tag(CAKKTabBar.Tab.cakeShop)
        
        Text("Search")
          .tag(CAKKTabBar.Tab.search)
        
        Text("Liked")
          .tag(CAKKTabBar.Tab.liked)
        
        ProfileTabCoordinator()
          .tag(CAKKTabBar.Tab.profile)
      }
      .toolbar(.hidden, for: .tabBar)
      
      CAKKTabBar(selectedTab: $selectedTab)
    }
  }
}


// MARK: - Previews

#Preview {
  AppTabView()
}
