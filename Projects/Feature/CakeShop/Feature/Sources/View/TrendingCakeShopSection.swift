//
//  TrendingCakeShopSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import DomainSearch
import LinkNavigator

import DIContainer

struct TrendingCakeShopSection: View {
  
  // MARK: - Properties
  
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @StateObject private var viewModel: TrendingCakeShopViewModel
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(TrendingCakeShopViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 12) {
      SectionHeaderLarge(title: "인기 케이크 샵")
        .padding(.horizontal, 16)
      
      Group {
        if viewModel.trendingCakeShopFetchingState == .loading {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(1...3, id: \.self) { _ in
                TrendingCakeShopSkeletonView()
              }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
          }
          .disabled(true)
        } else {
          if viewModel.trendingCakeShopFetchingState == .success && viewModel.trendingCakeShops.isEmpty {
            FailureStateView(title: "인기 케이크 샵 정보가 없어요")
          } else if viewModel.trendingCakeShopFetchingState == .failure {
            FailureStateView(title: "불러오기에 실패하였어요.", buttonTitle: "다시 시도") {
              viewModel.fetchTrendingCakeShop()
            }
          } else {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 16) {
                ForEach(viewModel.trendingCakeShops, id: \.shopId) { trendingCakeShop in
                  TrendingCakeShopView(trendingCakeShop: trendingCakeShop)
                    .onTapGesture {
                      let items = RouteHelper.ShopDetail.items(shopId: trendingCakeShop.shopId)
                      navigator?.next(paths: [RouteHelper.ShopDetail.path], items: items, isAnimated: true)
                    }
                }
              }
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
            }
          }
        }
      }
      .frame(height: 328)
    }
    .background(Color.white)
    .onFirstAppear {
      viewModel.fetchTrendingCakeShop()
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview("Success") {
  let diConatiner = DIContainer.shared.container
  diConatiner.register(TrendingCakeShopViewModel.self) { _ in
    let mockUseCase = MockTrendingCakeShopsUseCase()
    return .init(useCase: mockUseCase)
  }
  
  return TrendingCakeShopSection()
}

#Preview("Failure") {
  let diConatiner = DIContainer.shared.container
  diConatiner.register(TrendingCakeShopViewModel.self) { _ in
    let mockUseCase = MockTrendingCakeShopsUseCase(scenario: .failure)
    return .init(useCase: mockUseCase)
  }
  
  return TrendingCakeShopSection()
}
