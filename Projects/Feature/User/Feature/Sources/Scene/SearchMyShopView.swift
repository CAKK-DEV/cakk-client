//
//  SearchMyShopView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import CommonUtil
import DesignSystem

import LinkNavigator
import DIContainer

import AnalyticsService

struct SearchMyShopView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: SearchMyShopViewModel
  
  @FocusState private var isFocused
  @State private var isSearchResultShown = false
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(SearchMyShopViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      searchBar()
      
      if isSearchResultShown {
        searchResultView()
      } else {
        idleStateView()
      }
    }
    .onAppear {
      isFocused = true
      
      analytics?.logEngagement(view: self)
    }
    .onChange(of: isFocused) { isFocused in
      if isFocused {
        isSearchResultShown = false
      }
    }
  }
  
  private func searchBar() -> some View {
    HStack(spacing: 4) {
      Button {
        if isSearchResultShown {
          restoreSearch()
        } else {
          navigator?.back(isAnimated: true)
        }
      } label: {
        Image(systemName: "arrow.left")
          .font(.system(size: 20))
          .size(40)
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }
      .padding(.leading, -8)
      
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
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 28)
    .frame(height: 72)
    .background(Color.white)
  }
  
  @ViewBuilder
  private func searchResultView() -> some View {
    if viewModel.cakeShopFetchingState == .loading {
      VStack {
        ProgressView()
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      if viewModel.cakeShops.isEmpty {
        FailureStateView(title: "\"\(viewModel.searchKeyword)\"에 대한\n검색 결과가 없어요",
                         buttonTitle: "새로운 케이크 샵 등록 문의") {
          DialogManager.shared.showDialog(
            title: "케이크 샵 등록 문의",
            message: "케이크크 문의 채널을 통해서 등록되지 않은 케이크 샵 등록을 요청할 수 있어요.",
            primaryButtonTitle: "문의 채널로 이동",
            primaryButtonAction: .custom({
              if let url = URL(string: "https://www.instagram.com/cakeke_ke?igsh=MWM2ZXN6MjRncHhvbw%3D%3D&utm_source=qr") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
            }),
            secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        ScrollView {
          LazyVStack(spacing: 16) {
            ForEach(viewModel.cakeShops, id: \.shopId) { cakeShop in
              CakeShopThumbnailView(
                shopName: cakeShop.name,
                shopBio: cakeShop.bio,
                workingDays: cakeShop.workingDaysWithTime.map { $0.toWorkingDay() },
                profileImageUrl: cakeShop.profileImageUrl,
                cakeImageUrls: cakeShop.cakeImageUrls
              )
              .onAppear {
                if cakeShop.shopId == viewModel.cakeShops.last?.shopId {
                  viewModel.fetchMoreCakeShop()
                }
              }
              .onTapGesture {
                navigator?.next(paths: ["business_certification"], items: ["shopId": cakeShop.shopId.description], isAnimated: true)
              }
            }
            
            if viewModel.cakeShopFetchingState == .loadMore {
              ProgressView()
                .frame(height: 100)
            }
          }
          .padding(.vertical, 16)
          .padding(.horizontal, 28)
        }
      }
    }
  }
  
  private func idleStateView() -> some View {
    VStack {
      Text("내 케이크샵을 검색해 사장님 인증을 받고,\n손쉽게 가게를 꾸며보세요!")
        .font(.pretendard(size: 16))
        .multilineTextAlignment(.center)
        .foregroundStyle(DesignSystemAsset.gray30.swiftUIColor)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  
  // MARK: - Private Methods
  
  private func restoreSearch() {
    withAnimation(.smooth(duration: 0.28)) {
      isSearchResultShown = false
    }
    viewModel.searchKeyword.removeAll()
    isFocused = false
  }
  
  private func search() {
    withAnimation(.smooth(duration: 0.28)) {
      isSearchResultShown = true
    }
    viewModel.fetchCakeShop()
    isFocused = false
    
    analytics?.logEvent(name: "search_my_shop", parameters: ["keyword": viewModel.searchKeyword])
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(SearchMyShopViewModel.self) { _ in
    let searchCakeShopUseCase = MockSearchCakeShopUseCase()
    return SearchMyShopViewModel(searchCakeShopUseCase: searchCakeShopUseCase)
  }
  
  return SearchMyShopView()
}
