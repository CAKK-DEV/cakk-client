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

import FeatureBusiness
import DomainBusiness

struct ProfileTabCoordinator: View {
  
  @StateObject private var router = Router()
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      UserCoordinator()
        .navigationDestination(for: PublicUserDestination.self) { destination in
          switch destination {
          case .editCakeImage:
            EmptyView()
          case .editExternalLink:
            EmptyView()
          case .editLocation:
            EmptyView()
          case .editShopProfile:
            EmptyView()
          case .editWorkingDay:
            EmptyView()
          case .shopRegistration:
            ShopRegistrationCoordinator()
              .toolbar(.hidden, for: .navigationBar)
              .environmentObject(router)
          default:
            EmptyView()
          }
        }
    }
    .environmentObject(router)
  }
}

#Preview {
  ProfileTabCoordinator()
}
