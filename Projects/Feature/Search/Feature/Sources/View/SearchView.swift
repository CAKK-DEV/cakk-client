//
//  SearchView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DomainSearch

import DIContainer

struct SearchView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: SearchViewModel
  
  @State private var selectedSegmentItem = SearchResultView.SearchResultSection.images
  
  @State private var isSearchResultViewShown = false
  @FocusState private var isFocused
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(SearchViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      searchBar()
      
      if isSearchResultViewShown {
        SearchResultView(selectedSection: $selectedSegmentItem)
          .environmentObject(viewModel)
          .ignoresSafeArea()
      } else {
        searchIdleStateView()
      }
    }
  }
  
  private func searchBar() -> some View {
    VStack {
      HStack(spacing: 4) {
        if isSearchResultViewShown {
          Button {
            restoreSearch()
          } label: {
            Image(systemName: "arrow.left")
              .font(.system(size: 20))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .size(40)
          }
          .padding(.leading, -8)
        }
        
        
        RoundedRectangle(cornerRadius: 16)
          .fill(DesignSystemAsset.gray10.swiftUIColor)
          .frame(height: 48)
          .overlay {
            HStack(spacing: 12) {
              TextField("매장, 지역으로 검색해 보세요", text: $viewModel.searchKeyword)
                .font(.pretendard(size: 17, weight: .medium))
                .tint(DesignSystemAsset.brandcolor1.swiftUIColor)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                  search()
                }
              
              Button {
                search()
              } label: {
                DesignSystemAsset.magnifyingGlass.swiftUIImage
                  .resizable()
                  .size(18)
                  .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              }
              .modifier(BouncyPressEffect())
            }
            .padding(.horizontal, 20)
          }
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 28)
    .background(Color.white.ignoresSafeArea())
    .onFirstAppear {
      isFocused = true
    }
  }
  
  @ViewBuilder
  private func trendingKeywordSection(keywords: [String]) -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "인기 검색어", icon: DesignSystemAsset.chartArrowGrow.swiftUIImage)
        .padding(.horizontal, 28)
      
      if viewModel.searchKeywordFetchingState == .loading {
        VStack(spacing: 26) {
          ForEach(0..<5, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 8)
              .fill(DesignSystemAsset.gray10.swiftUIColor)
              .frame(width: 160, height: 18)
              .padding(.horizontal, 28)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 13)
      } else {
        ForEach(Array(keywords.enumerated()), id: \.offset) { index, keyword in
          Button {
            search(keyword: keyword)
          } label: {
            HStack(spacing: 8) {
              Text((index + 1).description)
                .font(.pretendard(size: 15, weight: .bold))
                .foregroundStyle(index >= 0 && index < 3
                                 ? Color(hex: "FF5CBE")
                                 : DesignSystemAsset.black.swiftUIColor)
                .frame(width: 20)
              
              Text(keyword)
                .font(.pretendard())
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
            .frame(minHeight: 48)
            .padding(.horizontal, 24)
          }
        }
      }
    }
  }
  
  private func searchIdleStateView() -> some View {
    ScrollView {
      VStack(spacing: 24) {
        trendingKeywordSection(keywords: viewModel.trendingSearchKeywords)
          .onFirstAppear {
            viewModel.fetchTrendingSearchKeywords()
          }
      }
      .padding(.top, 16)
    }
  }
  
  
  // MARK: - Private Methods
  
  private func search(keyword: String) {
    viewModel.searchKeyword = keyword
    search()
  }
  
  private func search() {
    if viewModel.searchKeyword.isEmpty { return }
    
    isFocused = false
    
    withAnimation(.smooth(duration: 0.28)) {
      isSearchResultViewShown = true
    }
    
    switch selectedSegmentItem {
    case .images:
      viewModel.fetchCakeImages()
    case .order:
      // TODO: Fetch cake shops
      break
    }
  }
  
  private func restoreSearch() {
    withAnimation(.smooth(duration: 0.28)) {
      isSearchResultViewShown = false
    }
    
    viewModel.searchKeyword.removeAll()
    isFocused = false
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(SearchViewModel.self) { resolver in
    let trendingSearchKeywordUseCase = MockTrendingSearchKeywordUseCase()
    let mockSearchCakeImagesUseCase = MockSearchCakeImagesUseCase()
    return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                           searchCakeImagesUseCase: mockSearchCakeImagesUseCase)
  }
  
  return SearchView()
}
