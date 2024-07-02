//
//  EditCakeShopImagesView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import Kingfisher

import DomainCakeShop

import DIContainer
import Router

public struct EditCakeShopImagesView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: EditCakeShopImagesViewModel
  @EnvironmentObject private var router: Router
  

  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditCakeShopImagesViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          router.navigateBack()
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("케이크 사진")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      if viewModel.imageFetchingState == .failure {
        FailureStateView(title: "이미지 로딩에 실패하였어요",
                         buttonTitle: "다시 시도",
                         buttonAction: {
          viewModel.fetchCakeImages()
        })
        .frame(maxWidth: .infinity, minHeight: .infinity)
      } else {
        if viewModel.imageFetchingState == .loading {
          VStack {
            ProgressView()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          if viewModel.cakeImages.isEmpty {
            FailureStateView(title: "등록된 이미지가 없어요")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else {
            ScrollView {
              VStack(spacing: 100) {
                FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
                  KFImage(URL(string: cakeImage.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(DesignSystemAsset.gray10.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .onAppear {
                      if cakeImage.id == viewModel.cakeImages.last?.id {
                        viewModel.fetchMoreCakeImages()
                      }
                    }
                    .onTapGesture {
                      router.navigate(to: EditCakeShopDestination.editCakeImageDetail(imageId: cakeImage.id))
                    }
                }
                
                if viewModel.imageFetchingState == .loadingMore {
                  ProgressView()
                }
              }
              .padding(12)
              .padding(.bottom, 200)
            }
          }
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      VStack {
        addNewImageButton()
          .padding(.bottom, 16)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onAppear {
      viewModel.fetchCakeImages()
    }
  }
  
  private func addNewImageButton() -> some View {
    Button {
      router.navigate(to: EditCakeShopDestination.newCakeImage(shopId: viewModel.shopId))
    } label: {
      VStack(spacing: 8) {
        Image(systemName: "plus")
          .font(.system(size: 20, weight: .bold))
        
        Text("사진 등록")
          .font(.pretendard(size: 12, weight: .bold))
      }
      .foregroundStyle(.white)
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 20)
        .fill(DesignSystemAsset.black.swiftUIColor)
      )
    }
    .modifier(BouncyPressEffect())
    .largeButtonShadow()
  }
}

// MARK: - Preview

import PreviewSupportCakeShop

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditCakeShopImagesViewModel.self) { _ in
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    return EditCakeShopImagesViewModel(shopId: 0, cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase)
  }
  return EditCakeShopImagesView()
}
