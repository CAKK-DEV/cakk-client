//
//  CakeCategoryDetailView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import Router

import DIContainer

struct CakeCategoryDetailView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @StateObject private var viewModel: CategoryDetailViewModel
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CategoryDetailViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      CategorySelectionNavigationView(selection: $viewModel.category)
        .onChange(of: viewModel.category) { _ in
          viewModel.fetchCakeImages()
        }
      
      if viewModel.imageFetchingState == .failure {
        FailureStateView(title: "이미지 로딩에 실패하였어요",
                         buttonTitle: "다시 시도",
                         buttonAction: {
          viewModel.fetchCakeImages()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        GeometryReader { proxy in
          ScrollView {
            let columns: Int = {
              switch proxy.size.width {
              case 0..<400:
                return 2
              case 400..<1000:
                return 3
              case 1000..<1400:
                return 4
              default:
                return 5
              }
            }()
            VStack(spacing: 100) {
              FlexibleGridView(columns: columns, data: viewModel.cakeImages) { cakeImage in
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


// MARK: - Preview

import PreviewSupportCakeShop

// Success scenario
#Preview {
  let diContainer = DIContainer.shared.container
  
  diContainer.register(CategoryDetailViewModel.self) { resolver in
    let useCase = MockCakeImagesByCategoryUseCase()
    return CategoryDetailViewModel(initialCategory: .threeDimensional,
                                   useCase: useCase)
  }
  
  return CakeCategoryDetailView()
}

// Failure scenario

#Preview {
  let diContainer = DIContainer.shared.container
  
  diContainer.register(CategoryDetailViewModel.self) { resolver in
    let useCase = MockCakeImagesByCategoryUseCase(scenario: .failure)
    return CategoryDetailViewModel(initialCategory: .threeDimensional,
                                   useCase: useCase)
  }
  
  return CakeCategoryDetailView()
}
