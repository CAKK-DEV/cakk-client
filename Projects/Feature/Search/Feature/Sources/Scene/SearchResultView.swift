//
//  SearchResultView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import Kingfisher

import CommonDomain
import DomainSearch

import LinkNavigator

import DIContainer
import AnalyticsService

struct SearchResultView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var viewModel: SearchViewModel
  
  private let sectionItems = SearchResultSection.allCases.map { $0.item }
  @Binding var selectedSection: SearchResultSection
  enum SearchResultSection: String, CaseIterable {
    case images = "사진"
    case cakeShop = "케이크 샵"
    
    var item: CKSegmentItem {
      CKSegmentItem(title: rawValue)
    }
  }
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init(selectedSection: Binding<SearchResultSection>) {
    _selectedSection = selectedSection
    
    let diContainer = DIContainer.shared.container
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      CKSegmentedControl(items: sectionItems, selection: .init(get: {
        selectedSection.item
      }, set: { item in
        self.selectedSection = SearchResultSection(rawValue: item.title)!
      }), size: .compact)
      
      TabView(selection: $selectedSection) {
        cakeImagesView()
          .tag(SearchResultSection.images)
        
        cakeShopsView()
          .tag(SearchResultSection.cakeShop)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
    .onAppear {
      analytics?.logEngagement(view: self)
    }
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
      if viewModel.imageFetchingState == .success && viewModel.cakeImages.isEmpty {
        FailureStateView(title: "검색 결과가 없어요")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        ScrollView {
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
                  let items = RouteHelper.ShopQuickInfo.items(imageId: cakeImage.id,
                                                              cakeImageUrl: cakeImage.imageUrl,
                                                              shopId: cakeImage.shopId)
                  navigator?.sheet(paths: [RouteHelper.ShopQuickInfo.path], items: items, isAnimated: true)
                  
                  analytics?.logEvent(name: "search_result_image_tap",
                                      parameters: [
                                        "shopId": cakeImage.shopId,
                                        "imageId": cakeImage.id
                                      ])
                }
            }
            
            if viewModel.imageFetchingState == .loading {
              ProgressView()
            }
          }
          .padding(.vertical, 16)
          .padding(.horizontal, 12)
        }
        .refreshable {
          viewModel.fetchCakeImages()
        }
      }
    }
  }
  
  @ViewBuilder
  private func cakeShopsView() -> some View {
    if viewModel.cakeShopFetchingState == .failure {
      FailureStateView(title: "케이크샵 검색에 실패하였어요",
                       buttonTitle: "다시 시도",
                       buttonAction: {
        viewModel.fetchCakeImages()
      })
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      if viewModel.cakeShopFetchingState == .success && viewModel.cakeShops.isEmpty {
        FailureStateView(title: "검색 결과가 없어요")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        ScrollView {
          LazyVStack(spacing: 16) {
            ForEach(viewModel.cakeShops, id: \.shopId) { cakeShop in
              CakeShopThumbnailView(
                shopName: cakeShop.name,
                shopBio: cakeShop.bio,
                workingDays: cakeShop.workingDaysWithTime.map { $0.workingDay.mapping() },
                profileImageUrl: cakeShop.profileImageUrl,
                cakeImageUrls: cakeShop.cakeImageUrls
              )
              .onFirstAppear {
                if viewModel.cakeShops.last?.shopId == cakeShop.shopId {
                  print("load more")
                  viewModel.fetchMoreCakeShops()
                }
              }
              .onTapGesture {
                let items = RouteHelper.ShopDetail.items(shopId: cakeShop.shopId)
                navigator?.next(paths: [RouteHelper.ShopDetail.path], items: items, isAnimated: true)
                analytics?.logEvent(name: "search_result_cakeshop_tap", parameters: ["shopId": cakeShop.shopId])
              }
            }
            
            if viewModel.cakeShopFetchingState == .loading {
              ProgressView()
                .frame(height: 100)
            }
          }
          .padding(.horizontal, 28)
          .padding(.vertical, 16)
        }
        .refreshable {
          viewModel.fetchCakeShops()
        }
      }
    }
  }
}

private extension WorkingDay {
  func mapping() -> CakeShopThumbnailView.WorkingDay {
    switch self {
    case .sun:
      return .sun
    case .mon:
      return .mon
    case .tue:
      return .tue
    case .wed:
      return .wed
    case .thu:
      return .thu
    case .fri:
      return .fri
    case .sat:
      return .sat
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

private struct PreviewContent: View {
  
  @StateObject var viewModel: SearchViewModel
  @State var selectedSegmentItem = SearchResultView.SearchResultSection.cakeShop
  private let scenario: MockSearchCakeImagesUseCase.Scenario
  
  init(scenario: MockSearchCakeImagesUseCase.Scenario) {
    self.scenario = scenario
    let trendingSearchKeywordUseCase = MockTrendingSearchKeywordUseCase()
    let mockSearchCakeImagesUseCase = MockSearchCakeImagesUseCase(scenario: scenario)
    let mockSearchCakeShopUseCase = MockSearchCakeShopUseCase()
    let viewModel =  SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                                     searchCakeImagesUseCase: mockSearchCakeImagesUseCase,
                                     searchCakeShopUseCase: mockSearchCakeShopUseCase)
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    SearchResultView(selectedSection: $selectedSegmentItem)
      .environmentObject(viewModel)
      .onAppear {
        viewModel.fetchCakeImages()
        viewModel.fetchCakeShops()
      }
  }
}


// MARK: - Preview

#Preview("Success") {
  PreviewContent(scenario: .success)
}

#Preview("Failure") {
  PreviewContent(scenario: .failure)
}
