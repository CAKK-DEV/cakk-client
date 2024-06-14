//
//  ProfileTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Router

import FeatureUser

struct ProfileTabCoordinator: View {
  
  @StateObject private var router = Router()
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      UserCoordinator()
    }
    .environmentObject(router)
  }
}

#Preview {
  ProfileTabCoordinator()
}
