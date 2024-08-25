//
//  CakeShopLIstView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DIContainer

struct CakeShopListView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: CakeShopListViewModel
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeShopListViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    Group {
      if viewModel.cakeShopFetchingState == .loading {
        ProgressView()
      } else {
        if viewModel.cakeShops.isEmpty {
          FailureStateView(title: "등록된 가게가 없어요")
        } else {
          ScrollView {
            LazyVStack(spacing: 16) {
              ForEach(viewModel.cakeShops, id: \.shopId) { cakeShop in
                EmptyView()
                // TODO: - Implement this
//                NavigationLink(destination: CakeShopDetailCoordinator(shopId: cakeShop.shopId)) {
//                  CakeShopThumbnailView(
//                    shopName: cakeShop.name,
//                    shopBio: cakeShop.bio,
//                    workingDays: [],
//                    profileImageUrl: cakeShop.profileImageUrl,
//                    cakeImageUrls: cakeShop.cakeImageUrls
//                  )
//                  .onFirstAppear {
//                    if viewModel.cakeShops.last?.shopId == cakeShop.shopId {
//                      print("load more")
//                      viewModel.fetchMoreCakeShop()
//                    }
//                  }
//                }
              }
              
              if viewModel.cakeShopFetchingState == .loadMore {
                ProgressView()
                  .frame(height: 100)
              }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
          }
          .refreshable {
            viewModel.fetchCakeShops()
          }
        }
      }
    }
    .navigationTitle("등록된 가게")
    .onFirstAppear {
      viewModel.fetchCakeShops()
    }
    .searchable(text: $viewModel.searchKeyword)
    .onSubmit(of: .search) {
      viewModel.fetchCakeShops()
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch
import PreviewSupportCakeShop

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopListViewModel.self) { _ in
    let searchCakeShopUseCase = MockSearchCakeShopUseCase()
    return CakeShopListViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
  }
  
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
    
    let viewModel = CakeShopDetailViewModel(
      shopId: 0,
      cakeShopDetailUseCase: cakeShopDetailUseCase,
      cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
      cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    viewModel.fetchCakeShopDetail()
    return viewModel
  }
  
  return NavigationStack {
    CakeShopListView()
  }
}
