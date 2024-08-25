//
//  CakeCategoryImageListView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import Kingfisher
import LinkNavigator
import DIContainer

import CommonDomain

struct CakeCategoryImageListView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: CakeCategoryImageListViewModel
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init(category: CakeCategory) {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeCategoryImageListViewModel.self)!
    viewModel.category = category
    _viewModel = .init(wrappedValue: viewModel)
    
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    Group {
      if viewModel.imageFetchingState == .failure {
        FailureStateView(
          title: "이미지 로딩에 실패하였어요",
          buttonTitle: "다시 시도",
          buttonAction: {
            viewModel.fetchCakeImages()
          }
        )
        .frame(maxWidth: .infinity, minHeight: .infinity)
      } else {
        if viewModel.imageFetchingState == .success && viewModel.cakeImages.isEmpty {
          FailureStateView(title: "검색 결과가 없어요")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          ScrollView {
            VStack(spacing: 100) {
              FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
                KFImage(URL(string: cakeImage.imageUrl))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .background(DesignSystemAsset.gray20.swiftUIColor)
                  .clipShape(RoundedRectangle(cornerRadius: 14))
                  .onAppear {
                    if cakeImage.id == viewModel.cakeImages.last?.id {
                      viewModel.fetchMoreCakeImages()
                    }
                  }
                  .onTapGesture {
                    let items = RouteHelper.ShopQuickInfo.items(imageId: cakeImage.id,
                                                                cakeImageUrl: cakeImage.imageUrl, 
                                                                shopId: cakeImage.shopId)
                    navigator?.sheet(paths: [RouteHelper.ShopQuickInfo.path], items: items, isAnimated: true)
                  }
              }

              if viewModel.imageFetchingState == .loading {
                ProgressView()
              }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
          }
        }
      }
    }
    .onFirstAppear {
      viewModel.fetchCakeImages()
    }
  }
}
