//
//  SearchCoordinator.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import Router
import DIContainer

public enum PublicSheetDestination: Identifiable {
  case quickInfo(shopId: Int, cakeImageUrl: String)

  public var id: String {
    switch self {
    case .quickInfo:
      return "ImageDetail"
    }
  }
}

public enum PublicDestination: Hashable {
  case shopDetail(shopId: Int)
}

public struct SearchCoordinator: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  private let diContainer = DIContainer.shared.container
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    SearchView()
      .environmentObject(router)
  }
}


// MARK: - Preview

import PreviewSupportSearch

private struct PreviewContent: View {
  
  @StateObject private var router = Router()
  private let diContainer = DIContainer.shared.container
  
  init() {
    let diContainer = DIContainer.shared.container
    diContainer.register(SearchViewModel.self) { resolver in
      let trendingSearchKeywordUseCase = MockTrendingSearchKeywordUseCase()
      let mockSearchCakeImagesUseCase = MockSearchCakeImagesUseCase()
      return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                             searchCakeImagesUseCase: mockSearchCakeImagesUseCase)
    }
  }
  
  var body: some View {
    NavigationStack(path: $router.navPath) {
      SearchCoordinator()
        .environmentObject(router)
    }
  }
}

#Preview {
  PreviewContent()
}
