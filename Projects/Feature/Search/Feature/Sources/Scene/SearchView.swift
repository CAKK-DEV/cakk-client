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

import LocationService

import DomainSearch

import DIContainer

struct SearchView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: SearchViewModel
  @StateObject var searchHistoryViewModel: SearchHistoryViewModel
  
  @State private var selectedSegmentItem = SearchResultView.SearchResultSection.images
  
  @State private var isSearchResultViewShown = false
  @FocusState private var isFocused
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(SearchViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    let searchHistoryViewModel = diContainer.resolve(SearchHistoryViewModel.self)!
    _searchHistoryViewModel = .init(wrappedValue: searchHistoryViewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      searchBar()
      
      if isSearchResultViewShown {
        SearchResultView(selectedSection: $selectedSegmentItem)
          .environmentObject(viewModel)
          .ignoresSafeArea()
          .onChange(of: selectedSegmentItem) { _ in
            search()
          }
      } else {
        searchIdleStateView()
      }
    }
    .onAppear {
      LocationService.shared.requestLocationPermission()
      LocationService.shared.startUpdatingLocation()
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
  
  private func searchHistorySection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "검색 기록", icon: DesignSystemAsset.timePast.swiftUIImage)
        .padding(.horizontal, 28)
      
      if searchHistoryViewModel.searchHistoryFetchingState == .loading {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach(1...3, id: \.self) { _ in
              RoundedRectangle(cornerRadius: 18)
                .fill(DesignSystemAsset.gray10.swiftUIColor)
                .frame(width: 120, height: 44)
            }
          }
          .padding(.vertical, 12)
          .padding(.horizontal, 28)
        }
      } else if searchHistoryViewModel.searchHistories.isEmpty {
        Text("검색 기록이 없습니다.")
          .font(.pretendard(size: 15))
          .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
          .frame(height: 68)
      } else {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(searchHistoryViewModel.searchHistories, id: \.id) { searchHistory in
              Button {
                search(keyword: searchHistory.keyword)
              } label: {
                HStack {
                  Text(searchHistory.keyword)
                    .font(.pretendard(size: 15, weight: .medium))
                    .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                    .padding(.leading, 16)
                  
                  Button {
                    withAnimation(.spring(duration: 0.2)) {
                      searchHistoryViewModel.removeSearchHistory(searchHistory)
                    }
                  } label: {
                    Image(systemName: "xmark.circle.fill")
                      .font(.system(size: 16))
                      .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                  }
                  .padding(.trailing, 12)
                }
                .frame(height: 44)
                .background(.white)
                .overlay {
                  RoundedRectangle(cornerRadius: 18)
                    .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
              }
            }
          }
          .padding(.vertical, 12)
          .padding(.horizontal, 28)
        }
      }
    }
    .onAppear {
      searchHistoryViewModel.fetchSearchHistory()
    }
  }
  
  private func searchIdleStateView() -> some View {
    ScrollView {
      VStack(spacing: 24) {
        searchHistorySection()
        
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

    searchHistoryViewModel.addSearchHistory(searchKeyword: viewModel.searchKeyword)
    
    switch selectedSegmentItem {
    case .images:
      if viewModel.lastSearchCakeImageKeyword != viewModel.searchKeyword {
        viewModel.fetchCakeImages()
      }
    case .cakeShop:
      if viewModel.lastSearchCakeShopKeyword != viewModel.searchKeyword {
        viewModel.fetchCakeShops()
      }
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
    let mockSearchCakeShopUseCase = MockSearchCakeShopUseCase()
    return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase,
                           searchCakeImagesUseCase: mockSearchCakeImagesUseCase,
                           searchCakeShopUseCase: mockSearchCakeShopUseCase)
  }
  
  diContainer.register(SearchHistoryViewModel.self) { resolver in
    let searchHistoryUseCase = MockSearchHistoryUseCase()
    return SearchHistoryViewModel(searchHistoryUseCase: searchHistoryUseCase)
  }
  
  return SearchView()
}
