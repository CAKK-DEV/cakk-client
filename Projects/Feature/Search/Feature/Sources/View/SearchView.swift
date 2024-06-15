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
      
      ScrollView {
        VStack(spacing: 24) {
          trendingKeywordSection(keywords: viewModel.trendingSearchKeywords)
        }
        .padding(.top, 16)
      }
    }
  }
  
  private func searchBar() -> some View {
    VStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(DesignSystemAsset.gray10.swiftUIColor)
        .frame(height: 48)
        .overlay {
          HStack(spacing: 12) {
            TextField("매장, 지역으로 검색해 보세요", text: .constant("검색어 어쩌구"))
              .font(.pretendard(size: 17, weight: .medium))
              .tint(DesignSystemAsset.brandcolor1.swiftUIColor)
            
            Button {
              // search action
            } label: {
              DesignSystemAsset.magnifyingGlass.swiftUIImage
                .resizable()
                .size(18)
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            }
          }
          .padding(.horizontal, 20)
        }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 28)
    .background(Color.white.ignoresSafeArea())
  }
  
  private func trendingKeywordSection(keywords: [String]) -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "인기 검색어", icon: DesignSystemAsset.chartArrowGrow.swiftUIImage)
        .padding(.horizontal, 28)
      
      ForEach(Array(keywords.enumerated()), id: \.offset) { index, keyword in
        Button {
          // search with keyword action
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
    .onAppear {
      viewModel.fetchTrendingSearchKeywords()
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(SearchViewModel.self) { resolver in
    let trendingSearchKeywordUseCase = MockTrendingSearchKeywordUseCase()
    return SearchViewModel(trendingSearchKeywordUseCase: trendingSearchKeywordUseCase)
  }
  
  return SearchView()
}
