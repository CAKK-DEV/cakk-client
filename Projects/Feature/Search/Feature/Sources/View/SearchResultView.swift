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
    case order = "케이크 샵"
    
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
        
        Text("cake shop search result")
          .tag(SearchResultSection.order)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
  }
  
  @ViewBuilder
  private func cakeImagesView() -> some View {
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
                  router.presentSheet(destination: PublicSheetDestination.quickInfo(shopId: cakeImage.shopId, cakeImageUrl: cakeImage.imageUrl))
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
}


// MARK: - Preview

import PreviewSupportSearch

private struct PreviewContent: View {
  
  @StateObject var viewModel: SearchViewModel
  @State var selectedSegmentItem = SearchResultView.SearchResultSection.images
  private let scenario: MockSearchCakeImagesUseCase.Scenario
  
  init(scenario: MockSearchCakeImagesUseCase.Scenario) {
    self.scenario = scenario
    let trendingSearchKeywordUseCase = MockTrendingSearchKeywordUseCase()
    let mockSearchCakeImagesUseCase = MockSearchCakeImagesUseCase(scenario: scenario)
    let viewModel =  SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                                     searchCakeImagesUseCase: mockSearchCakeImagesUseCase)
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    SearchResultView(selectedSection: $selectedSegmentItem)
      .environmentObject(viewModel)
      .onAppear {
        viewModel.fetchCakeImages()
      }
  }
}

#Preview {
  PreviewContent(scenario: .success)
}

#Preview {
  PreviewContent(scenario: .failure)
}
