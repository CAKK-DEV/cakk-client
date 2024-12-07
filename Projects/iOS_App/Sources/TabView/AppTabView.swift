//
//  AppTabView.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import FeatureUser
import FeatureOnboarding
import FeatureCakeShop
import FeatureSearch

struct AppTabView: View {
  
  // MARK: - Properties
  
  @StateObject var tabStateManager = TabStateManager()
  @StateObject private var keyboardObserver = KeyboardObserver()
  
  // MARK: - Views
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $tabStateManager.selectedTab) {
        SearchCakeShopOnMapView()
          .tag(CAKKTabBar.Tab.main)
        
        SearchView()
          .tag(CAKKTabBar.Tab.search)
        
        LikedItemsView()
          .toolbar(.hidden, for: .tabBar)
          .tag(CAKKTabBar.Tab.liked)
        
        ProfileView()
          .tag(CAKKTabBar.Tab.profile)
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
      .toolbar(.hidden, for: .tabBar)
      
      CAKKTabBar(selectedTab: $tabStateManager.selectedTab)
        .ignoresSafeArea(.keyboard)
        .offset(y: keyboardObserver.isKeyboardVisible ? 200 : 0)
        .animation(.snappy, value: keyboardObserver.isKeyboardVisible)
    }
    .environmentObject(keyboardObserver)
  }
}


// MARK: - Previews

#Preview {
  AppTabView()
}
