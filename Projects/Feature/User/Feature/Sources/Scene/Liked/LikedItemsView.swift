//
//  LikedItemsView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import SwiftUIUtil

import Kingfisher

import UserSession

import DomainUser

import Router
import DIContainer

struct LikedItemsView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: LikedItemsViewModel
  @EnvironmentObject private var router: Router
  
  @StateObject private var userSession = UserSession.shared
  
  @State var selectedSection: SearchResultSection = .images
  enum SearchResultSection: String, CaseIterable {
    case images = "사진"
    case cakeShop = "케이크 샵"
    
    var item: CKSegmentItem {
      CKSegmentItem(title: rawValue)
    }
  }
  
  
  // MARK: - Initializers
  
  init() {
    let container = DIContainer.shared.container
    let viewModel = container.resolve(LikedItemsViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(isDividerShown: false,
                    centerContent: {
        Text("저장됨")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      if userSession.isSignedIn {
        CKSegmentedControl(items: SearchResultSection.allCases.map { $0.item },
                           selection: .init(get: {
          selectedSection.item
        }, set: { item in
          self.selectedSection = SearchResultSection(rawValue: item.title)!
        }), size: .compact)
        
        TabView(selection: $selectedSection) {
          cakeImagesView()
            .tag(SearchResultSection.images)
            .onFirstAppear {
              viewModel.fetchCakeImages()
            }
        
          cakeShopsView()
            .tag(SearchResultSection.cakeShop)
            .onFirstAppear {
              viewModel.fetchCakeShops()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      } else {
        notLoggedInStateView()
      }
    }
  }
  
  private func notLoggedInStateView() -> some View {
    FailureStateView(title: "로그인이 필요한 기능이에요!",
                     buttonTitle: "로그인하고 다양한 기능 누리기", 
                     buttonAction: {
      router.presentSheet(destination: SheetDestination.login)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  private func cakeImagesView() -> some View {
    if viewModel.imageFetchingState == .failure {
      FailureStateView(title: "이미지 검색에 실패하였어요",
                       buttonTitle: "다시 시도",
                       buttonAction: {
        viewModel.fetchCakeImages()
      })
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      if viewModel.imageFetchingState == .loading && viewModel.cakeImages.isEmpty {
        VStack {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if viewModel.cakeImages.isEmpty {
        FailureStateView(title: "아직 저장된 케이크 사진이 없어요")
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
                  if cakeImage.cakeHeartId == viewModel.cakeImages.last?.cakeHeartId {
                    viewModel.fetchMoreCakeImages()
                  }
                }
                .onTapGesture {
                  router.presentSheet(destination: PublicSheetDestination.quickInfo(
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
          .padding(.horizontal, 12)
          .padding(.top, 16)
          .padding(.bottom, 100)
        }
      }
    }
  }
  
  @ViewBuilder
  private func cakeShopsView() -> some View {
    if viewModel.cakeShopFetchingState == .failure {
      FailureStateView(title: "저장된 케이크 샵 불러오기에 실패하였어요",
                       buttonTitle: "다시 시도",
                       buttonAction: {
        viewModel.fetchCakeShops()
      })
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      if viewModel.cakeShopFetchingState == .loading && viewModel.cakeShops.isEmpty {
        VStack {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if viewModel.cakeShops.isEmpty {
        FailureStateView(title: "아직 저장된 케이크샵이 없어요")
      } else {
        ScrollView {
          LazyVStack(spacing: 16) {
            ForEach(viewModel.cakeShops, id: \.shopHeartId) { cakeShop in
              CakeShopThumbnailView(
                shopName: cakeShop.name,
                shopBio: cakeShop.bio,
                workingDays: cakeShop.workingDays.map { $0.mapping() },
                profileImageUrl: cakeShop.profileImageUrl,
                cakeImageUrls: cakeShop.cakeImageUrls
              )
              .onFirstAppear {
                if viewModel.cakeShops.last?.shopHeartId == cakeShop.shopHeartId {
                  print("load more")
                  viewModel.fetchMoreCakeShops()
                }
              }
              .onTapGesture {
                // TODO: Navigate to shop Detail
                router.navigate(to: PublicDestination.shopDetail(shopId: cakeShop.id))
              }
            }
            
            if viewModel.cakeShopFetchingState == .loading {
              ProgressView()
                .frame(height: 100)
            }
          }
          .padding(.horizontal, 28)
          .padding(.top, 16)
          .padding(.bottom, 100)
        }
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportUser

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(LikedItemsViewModel.self) { _ in
    let likeCakeImageUseCase = MockLikeCakeImageUseCase()
    let likeCakeShopUseCase = MockLikeCakeShopUseCase()
    return LikedItemsViewModel(likeCakeImageUseCase: likeCakeImageUseCase,
                               likeCakeShopUseCase: likeCakeShopUseCase)
  }
  return LikedItemsView()
}