//
//  SearchTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import FeatureSearch

struct SearchTabCoordinator: View {
  
  @StateObject private var router = Router()
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      SearchCoordinator()
    }
    .environmentObject(router)
  }
}

#Preview {
  SearchTabCoordinator()
}
