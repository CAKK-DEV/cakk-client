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

import FeatureSearch

struct CakeShopTabCoordinator: View {
  
  @StateObject private var router = Router()
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      CakeShopCoordinator()
        .navigationDestination(for: PublicDestination.self) { destination in
          switch destination {
          case .map:
            SearchCakeShopOnMapView()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
          }
        }
    }
    .environmentObject(router)
  }
}

#Preview {
  CakeShopTabCoordinator()
}
