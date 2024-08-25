//
//  CakeCategoryImageListView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import Kingfisher

import Router

import DIContainer

import CommonDomain

struct CakeCategoryImageListView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @StateObject private var viewModel: CakeCategoryImageListViewModel
  
  
  // MARK: - Initializers
  
  init(category: CakeCategory) {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeCategoryImageListViewModel.self)!
    viewModel.category = category
    _viewModel = .init(wrappedValue: viewModel)
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
                    router.presentSheet(destination: CakeShopSheetDestination.quickInfo(
                      imageId: cakeImage.id,
                      cakeImageUrl: cakeImage.imageUrl,
                      shopId: cakeImage.shopId
                    ))
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
