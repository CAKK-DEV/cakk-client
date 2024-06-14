//
//  CakeShopTabCoordinator.swift
//  CAKK
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import FeatureCakeShop
import Router

struct CakeShopTabCoordinator: View {
  
  @StateObject private var router = Router()
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopCoordinator()
    }
    .environmentObject(router)
  }
}

#Preview {
  CakeShopTabCoordinator()
}
