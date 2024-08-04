//
//  CAKKAdminApp.swift
//  CAKK-Admin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DIContainer
import Swinject

@main
struct CAKKAdminApp: App {
  
  // MARK: - Initializers
  
  init() {
    setupDIContainer()
  }
  
  
  // MARK: - Internal Methods
  
  var body: some Scene {
    WindowGroup {
      AppCoordinator()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func setupDIContainer() {
    let assembler = Assembler([
      ImageUploaderAssembly(),
      FeatureUserAssembly(),
      FeatureCakeShopAssembly(),
      FeatureSearchAssembly()
    ])
    DIContainer.shared.container = assembler.resolver as! Container
  }
}
