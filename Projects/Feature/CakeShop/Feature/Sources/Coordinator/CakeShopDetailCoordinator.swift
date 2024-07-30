//
//  CakeShopDetailCoordinator.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/22/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil

import Router
import DIContainer


// MARK: - Destination

public enum CakeShopDetailFullScreenSheetDestination: Identifiable {
  case imageFullScreen(imageUrl: String)
  
  public var id: String {
    switch self {
    case .imageFullScreen:
      return "ImageFullScreen"
    }
  }
}


// MARK: - Coordinator

public struct CakeShopDetailCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    CakeShopDetailView()
      .fullScreenCover(item: $router.presentedFullScreenSheet, content: { sheet in
        if let destination = sheet.destination as? CakeShopDetailFullScreenSheetDestination {
          switch destination {
          case .imageFullScreen(let imageUrl):
            ImageZoomableView(imageUrl: imageUrl)
              .background(ClearBackgroundView())
          }
        }
      })
      .navigationBarBackButtonHidden()
      .environmentObject(router)
  }
}

// MARK: - Preview

#Preview {
  CakeShopDetailCoordinator()
}
