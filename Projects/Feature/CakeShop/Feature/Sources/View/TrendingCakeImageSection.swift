//
//  TrendingCakeImageSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil

import DesignSystem

import DIContainer
import Router

struct TrendingCakeImageSection: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: TrendingCakeImagesViewModel
  @State private var columns = 2
  
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(TrendingCakeImagesViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 12) {
      SectionHeaderLarge(title: "인기 케이크")
        .padding(.horizontal, 16)
      
      VStack(spacing: 100) {
        FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
          AsyncImage(
            url: URL(string: cakeImage.imageUrl),
            transaction: Transaction(animation: .easeInOut)
          ) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onAppear {
                  if cakeImage.id == viewModel.cakeImages.last?.id {
                    viewModel.fetchMoreCakeImages()
                  }
                }
            default:
              RoundedRectangle(cornerRadius: 14)
                .fill(DesignSystemAsset.gray20.swiftUIColor)
                .aspectRatio(3/4, contentMode: .fit)
            }
          }
          .onTapGesture {
            router.presentSheet(destination: SheetDestination.quickInfo(
              imageId: cakeImage.id,
              cakeImageUrl: cakeImage.imageUrl,
              shopId: cakeImage.shopId)
            )
          }
        }
        
        if viewModel.imageFetchingState == .loading {
          ProgressView()
        }
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 12)
    }
    .onFirstAppear {
      viewModel.fetchCakeImages()
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop

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
