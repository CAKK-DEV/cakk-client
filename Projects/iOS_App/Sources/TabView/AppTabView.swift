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

struct AppTabView: View {
  
  // MARK: - Properties
  
  @StateObject var tabStateManager = TabStateManager()
  @StateObject private var keyboardObserver = KeyboardObserver()
  
  // MARK: - Views
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $tabStateManager.selectedTab) {
        CakeShopTabCoordinator()
          .tag(CAKKTabBar.Tab.cakeShop)
        
        SearchTabCoordinator()
          .tag(CAKKTabBar.Tab.search)
        
        LikeTabCoordinator()
          .toolbar(.hidden, for: .tabBar)
          .tag(CAKKTabBar.Tab.liked)
        
        ProfileTabCoordinator()
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
