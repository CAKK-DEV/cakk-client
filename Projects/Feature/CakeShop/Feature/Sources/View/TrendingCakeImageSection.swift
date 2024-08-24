//
//  TrendingCakeImageSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import Kingfisher

import DIContainer
import LinkNavigator

struct TrendingCakeImageSection: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: TrendingCakeImagesViewModel
  @State private var columns = 2
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(TrendingCakeImagesViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 12) {
      SectionHeaderLarge(title: "인기 케이크")
        .padding(.horizontal, 16)
      
      VStack(spacing: 100) {
        FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
          CakeImageGridItem(imageUrlString: cakeImage.imageUrl)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onAppear {
              if cakeImage.id == viewModel.cakeImages.last?.id {
                viewModel.fetchMoreCakeImages()
              }
            }
            .onTapGesture {
              let items = [
                "imageId": cakeImage.id.description,
                "cakeImageUrl": cakeImage.imageUrl,
                "shopId": cakeImage.shopId.description
              ]
              navigator?.sheet(paths: ["shop_quick_info"], items: items, isAnimated: true)
            }
        }
        
        if viewModel.imageFetchingState == .loading {
          ProgressView()
        }
      }
      .padding(12)
    }
    .onFirstAppear {
      viewModel.fetchCakeImages()
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(TrendingCakeImagesViewModel.self) { _ in
    let mockUseCase = MockTrendingCakeImagesUseCase()
    return .init(useCase: mockUseCase)
  }
  
  return ScrollView {
    TrendingCakeImageSection()
  }
}
