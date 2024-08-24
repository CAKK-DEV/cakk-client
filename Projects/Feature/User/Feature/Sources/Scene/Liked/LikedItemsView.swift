//
//  LikedItemsView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import CommonUtil

import Kingfisher

import UserSession

import DomainUser

import LinkNavigator
import DIContainer

import AnalyticsService

public struct LikedItemsView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: LikedItemsViewModel
  
  @StateObject private var userSession = UserSession.shared
  
  @State var selectedSection: SearchResultSection = .images
  enum SearchResultSection: String, CaseIterable {
    case images = "사진"
    case cakeShop = "케이크 샵"
    
    var item: CKSegmentItem {
      CKSegmentItem(title: rawValue)
    }
  }
  
  @StateObject var tabDoubleTapObserver = TabDoubleTapObserver(.doubleTapLikedTab)
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init() {
    let container = DIContainer.shared.container
    let viewModel = container.resolve(LikedItemsViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.analytics = container.resolve(AnalyticsService.self)
    self.navigator = container.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    if userSession.isSignedIn {
      VStack(spacing: 0) {
        navigationBar()
        
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
              /// Paging 했을 때 즉시 데이터를 요청하게 되면 페이징이 중간에 멈추는 이슈 때문에 delay를 추가하였습니다
              DispatchQueue.main.asyncAfter(deadline: .now()) {
                viewModel.fetchCakeImages()
              }
            }
        
          cakeShopsView()
            .tag(SearchResultSection.cakeShop)
            .onFirstAppear {
              /// Paging 했을 때 즉시 데이터를 요청하게 되면 페이징이 중간에 멈추는 이슈 때문에 delay를 추가하였습니다
              DispatchQueue.main.asyncAfter(deadline: .now()) {
                viewModel.fetchCakeShops()
              }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      }
    } else {
      VStack(spacing: 0) {
        navigationBar()
        notLoggedInStateView()
      }
    }
  }
  
  private func navigationBar() -> some View {
    NavigationBar(isDividerShown: false,
                  centerContent: {
      Text("저장됨")
        .font(.pretendard(size: 17, weight: .bold))
        .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
    })
  }
  
  private func notLoggedInStateView() -> some View {
    FailureStateView(title: "로그인이 필요한 기능이에요!",
                     buttonTitle: "로그인하고 다양한 기능 누리기", 
                     buttonAction: {
      navigator?.fullSheet(paths: ["login"], items: [:], isAnimated: true, prefersLargeTitles: false)
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
          .onAppear {
            if GlobalSettings.didChangeCakeImageLikeState {
              viewModel.fetchCakeImages()
            }
          }
      } else {
        ScrollViewReader { scrollProxy in
          ScrollView {
            VStack(spacing: 0) {
              /// Scroll to top에 사용되는 임의 뷰 입니다.
              Color.clear.frame(height: 0.01)
                .id("first_section")
              
              VStack(spacing: 100) {
                FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
                  KFImage(URL(string: cakeImage.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(DesignSystemAsset.gray10.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .onFirstAppear {
                      if cakeImage.cakeHeartId == viewModel.cakeImages.last?.cakeHeartId {
                        viewModel.fetchMoreCakeImages()
                      }
                    }
                    .onTapGesture {
                      let items = [
                        "imageId": cakeImage.imageId.description,
                        "cakeImageUrl": cakeImage.imageUrl,
                        "shopId": cakeImage.shopId.description
                      ]
                      navigator?.sheet(paths: ["shop_quick_info"], items: items, isAnimated: true)
                    }
                }
                .animation(.snappy, value: viewModel.cakeImages)
                
                if viewModel.imageFetchingState == .loading {
                  ProgressView()
                }
              }
              .padding(.horizontal, 12)
              .padding(.top, 16)
              .padding(.bottom, 100)
            }
          }
          .refreshable {
            viewModel.fetchCakeImages()
          }
          .onAppear {
            if GlobalSettings.didChangeCakeShopLikeState {
              viewModel.fetchCakeImages()
            }
            
            analytics?.logEngagement(view: self)
          }
          .onChange(of: tabDoubleTapObserver.doubleTabActivated) { _ in
            if selectedSection == .images {
              withAnimation {
                scrollProxy.scrollTo("first_section")
              }
            }
          }
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
          .onAppear {
            if GlobalSettings.didChangeCakeShopLikeState {
              viewModel.fetchCakeShops()
            }
          }
      } else {
        ScrollViewReader { scrollProxy in
          ScrollView {
            VStack(spacing: 0) {
              /// Scroll to top에 사용되는 임의 뷰 입니다.
              Color.clear.frame(height: 0.01)
                .id("first_section")
              
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
                      viewModel.fetchMoreCakeShops()
                    }
                  }
                  .onTapGesture {
                    navigator?.next(paths: ["shop_detail"], items: ["shopId": cakeShop.id.description], isAnimated: true)
                  }
                }
                .animation(.snappy, value: viewModel.cakeShops)
                
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
          .refreshable {
            if GlobalSettings.didChangeCakeShopLikeState {
              viewModel.fetchCakeShops()
            }
          }
          .onAppear {
            if GlobalSettings.didChangeCakeShopLikeState {
              viewModel.fetchCakeShops()
            }
          }
          .onChange(of: tabDoubleTapObserver.doubleTabActivated) { _ in
            if selectedSection == .cakeShop {
              withAnimation {
                scrollProxy.scrollTo("first_section")
              }
            }
          }
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
