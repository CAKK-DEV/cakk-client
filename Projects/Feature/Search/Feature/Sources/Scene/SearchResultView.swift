//
//  SearchResultView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DomainSearch

import Router

struct SearchResultView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var viewModel: SearchViewModel
  @EnvironmentObject private var router: Router
  
  private let sectionItems = SearchResultSection.allCases.map { $0.item }
  @Binding var selectedSection: SearchResultSection
  enum SearchResultSection: String, CaseIterable {
    case images = "사진"
    case cakeShop = "케이크 샵"
    
    var item: CKSegmentItem {
      CKSegmentItem(title: rawValue)
    }
  }
  
  // MARK: - Initializers
  
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
      ScrollView {
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
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
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
              router.navigate(to: PublicDestination.shopDetail(shopId: cakeShop.shopId))
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

#Preview {
  PreviewContent(scenario: .success)
}

#Preview {
  PreviewContent(scenario: .failure)
}
