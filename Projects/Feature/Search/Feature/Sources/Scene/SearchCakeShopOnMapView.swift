//
//  SearchCakeShopOnMapView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/19/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil

import DesignSystem

import Kingfisher

import DomainSearch

import MapKit
import SwiftUIPager

import DIContainer
import LinkNavigator

import LocationService

import AdManager

import AnalyticsService

public struct SearchCakeShopOnMapView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: SearchCakeShopOnMapViewModel
  
  @State private var isRefreshButtonShown = false
  
  @State private var cakeShopViewDragOffset: CGSize = .zero
  @State private var cakeShopViewScale: CGFloat = 1
  
  @StateObject private var motionData = MotionObserver()
  
  @StateObject private var interstitialAdManager = InterstitialAdsManager()
  
  @State private var isNoResultViewShown = false
  @State private var attempts: Int = 0

  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  @Namespace private var namespace
  
  @StateObject private var page: Page = .first()
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(SearchCakeShopOnMapViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.locatedCakeShops) { shop in
        let coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        return MapAnnotation(coordinate: coordinate) {
          ZStack {
            let isSelected = shop == viewModel.selectedCakeShop
            
            VStack(spacing: 6) {
              DesignSystemAsset.shopMarkerLarge.swiftUIImage
                .resizable()
                .frame(width: 46)
                .scaledToFit()
                .scaleEffect(isSelected ? 1.0 : 0)
                .offset(y: isSelected ? 0 : 20)
                .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1), value: isSelected)
              
              Text(shop.name)
                .font(.pretendard(size: 12, weight: .bold))
                .opacity(isSelected ? 1.0 : 0.0)
                .scaleEffect(isSelected ? 1.0 : 0.3)
                .opacity(isSelected ? 1.0 : 0.0)
                .offset(y: isSelected ? 0 : -16)
                .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1).delay(0.1), value: isSelected)
            }
            .padding(.bottom, 30)
            
            DesignSystemAsset.shopMarkerRegular.swiftUIImage
              .resizable()
              .size(32)
              .padding(.bottom, 16)
              .padding()
              .scaleEffect(isSelected ? 0.0 : 1.0)
              .offset(y: isSelected ? 16 : 0.0)
              .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1), value: isSelected)
          }
          .onTapGesture {
            viewModel.setSelected(cakeShop: shop)
            
            if let index = viewModel.locatedCakeShops.firstIndex(of: shop) {
              page.update(.new(index: index))
            }
          }
        }
      }
      .animation(.smooth)
      .ignoresSafeArea()
      .simultaneousGesture(
        DragGesture()
          .onChanged { _ in
            isRefreshButtonShown = true
          }
      )
      
      // Navigation bar
      VStack(spacing: 0) {
        navigationBar()
        Spacer()
      }
      .padding(.top, 8)
      
      // Bottom CakeShop Pager
      VStack(spacing: 16) {
        Spacer()
        
        if viewModel.locatedCakeShops.isEmpty == false {
          Pager(
            page: page,
            data: viewModel.locatedCakeShops,
            id: \.self) { cakeShop in
              cakeShopView(cakeShop)
            }
            .onPageChanged { newIndex in
              let selectedCakeShop = viewModel.locatedCakeShops[newIndex]
              
              viewModel.setSelected(cakeShop: selectedCakeShop)
              viewModel.region = .init(center: .init(latitude: selectedCakeShop.latitude, longitude: selectedCakeShop.longitude),
                                       span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
            .preferredItemSize(CGSize(width: 319, height: 176))
            .itemSpacing(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .alignment(.start(20))
            .multiplePagination()
            .sensitivity(.high)
            .bounces(true)
            .frame(height: 176)
            .animation(.snappy, value: page.index)
            .padding(.vertical, 16)
            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 4)
        }
      }
    }
    .onFirstAppear {
      viewModel.fetchLocatedCakeShops()
      
      if LocationService.shared.authorizationStatus == .notDetermined {
        LocationService.shared.requestLocationPermission()
      } else if LocationService.shared.authorizationStatus != .authorizedAlways
                  && LocationService.shared.authorizationStatus != .authorizedWhenInUse {
        DialogManager.shared.showDialog(.locationPermissionDenied(completion: {
          navigator?.back(isAnimated: true)
        }))
      }
    }
    .onAppear {
      interstitialAdManager.loadInterstitialAd(adUnit: .mapDistanceAd)
      analytics?.logEngagement(view: self)
    }
    .onChange(of: viewModel.locatedCakeShopsFetchingState) { state in
      if state == .success {
        isRefreshButtonShown = false
      } else {
        isRefreshButtonShown = true
      }
    }
    .onReceive(viewModel.$locatedCakeShops.dropFirst()) { searchResultCakeShops in
      if searchResultCakeShops.isEmpty {
        showNoSearchResultView()
      } else {
        if viewModel.searchDistanceOption.isAdRequired {
          interstitialAdManager.displayInterstitialAd(adUnit: .mapDistanceAd)
        }
      }
    }
  }
  
  private func cakeShopView(_ cakeShop: LocatedCakeShop?) -> some View {
    VStack(spacing: 16) {
      HStack(alignment: .top, spacing: 0) {
        if let profileImageUrl = cakeShop?.profileImageUrl {
          KFImage(URL(string: profileImageUrl))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(60)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(Circle())
            .overlay {
              Circle()
                .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 0.5)
            }
        } else {
          Circle()
            .fill(DesignSystemAsset.gray10.swiftUIColor)
            .size(60)
            .overlay {
              DesignSystemAsset.cakePin.swiftUIImage
                .resizable()
                .scaledToFit()
                .size(32)
            }
        }
        
        VStack(spacing: 6) {
          Text(cakeShop?.name ?? "")
            .font(.pretendard(size: 15, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
          
          Text(cakeShop?.bio ?? "")
            .font(.pretendard(size: 13, weight: .medium))
            .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
        }
        .padding(.leading, 12)
      }
      
      HStack(spacing: 6) {
        ForEach(0..<4, id: \.self) { index in
          if let imageUrlString = cakeShop?.cakeImageUrls[safe: index] {
            Color.clear
              .overlay {
                KFImage(URL(string: imageUrlString))
                  .placeholder {
                    DesignSystemAsset.cakePin.swiftUIImage
                      .resizable()
                      .scaledToFit()
                      .size(40)
                  }
                  .resizable()
                  .scaledToFill()
                  .frame(maxWidth: .infinity)
                  .background(DesignSystemAsset.gray10.swiftUIColor)
              }
              .aspectRatio(1/1, contentMode: .fit)
              .clipShape(RoundedRectangle(cornerRadius: 13))
          } else {
            DesignSystemAsset.gray10.swiftUIColor
              .aspectRatio(1/1, contentMode: .fit)
              .clipShape(RoundedRectangle(cornerRadius: 13))
              .overlay {
                DesignSystemAsset.cakePin.swiftUIImage
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32)
                  .contentShape(Rectangle())
              }
          }
        }
      }
      .frame(maxWidth: .infinity)
    }
    .padding(16)
    .background(Color.white.ignoresSafeArea())
    .clipShape(RoundedRectangle(cornerRadius: 22))
    .modifier(BouncyPressEffect())
    .onTapGesture {
      if let shopId = cakeShop?.id {
        let items = RouteHelper.ShopDetail.items(shopId: shopId)
        navigator?.next(paths: [RouteHelper.ShopDetail.path], items: items, isAnimated: true)
      }
    }
  }
  
  private func navigationBar() -> some View {
    VStack {
      HStack(spacing: 8) {
        searchBar()
          .frame(maxWidth: .infinity)
        
        moveToMyLocationButton()
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .zIndex(1)
      
      refreshButton()
        .padding(.top, 20)
        .zIndex(0)
    }
  }
  
  private func refreshButton() -> some View {
    Button {
      viewModel.fetchLocatedCakeShops()
      
      analytics?.logEvent(name: "refresh_on_map_tap",
                          parameters: [
                            "distance_option": viewModel.searchDistanceOption.displayName
                          ])
    } label: {
      let isLoading = viewModel.locatedCakeShopsFetchingState == .loading
      
      HStack(spacing: 12) {
        Text(isLoading ? "검색중" : "이 지역 재검색")
          .font(.pretendard(size: 15, weight: .semiBold))
          .foregroundStyle(isLoading ? .white.opacity(0.65) : .white)
          .padding(.leading, 20)
        
        if isLoading {
          ProgressView()
            .tint(.white)
            .padding(.trailing, 20)
        } else {
          distanceSelector()
            .padding(.vertical, 4)
            .padding(.trailing, 4)
        }
      }
      .frame(height: 48)
      .background(DesignSystemAsset.black.swiftUIColor)
      .clipShape(Capsule())
      .overlay {
        Capsule()
          .stroke(DesignSystemAsset.gray70.swiftUIColor, lineWidth: 2)
      }
      .shadow(color: .black.opacity(0.25), radius: 20, y: 4)
    }
    .modifier(BouncyPressEffect())
    .opacity(isRefreshButtonShown ? 1.0 : 0.0)
    .offset(y: isRefreshButtonShown ? 0 : -60)
    .animation(.snappy, value: isRefreshButtonShown)
    .disabled(viewModel.locatedCakeShopsFetchingState == .loading)
  }
  
  private func searchBar() -> some View {
    HStack(spacing: 8) {
      Text("매장, 지역으로 검색해 보세요")
        .font(.pretendard(size: 17, weight: .medium))
        .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
      
      DesignSystemAsset.magnifyingGlass.swiftUIImage
        .resizable()
        .size(18)
        .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        .padding(.trailing, 18)
    }
    .frame(height: 48)
    .background(DesignSystemAsset.white.swiftUIColor)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 4)
    .onTapGesture {
      let items = RouteHelper.Search.items()
      navigator?.next(paths: [RouteHelper.Search.path], items: items, isAnimated: true)
    }
  }
  
  private func moveToMyLocationButton() -> some View {
    Button {
      viewModel.moveToUserLocation()
    } label: {
      RoundedRectangle(cornerRadius: 16)
        .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1.5)
        .overlay {
          Image(systemName: "location.fill")
            .font(.system(size: 18))
            .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
            .frame(width: 40, height: 40)
        }
        .background(DesignSystemAsset.white.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    .size(48)
    .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 4)
    .modifier(BouncyPressEffect())
  }
  
  private func distanceSelector() -> some View {
    HStack(spacing: 3) {
      ForEach(SearchDistanceOption.allCases, id: \.self) { distanceOption in
        let isSelectedDistance = viewModel.searchDistanceOption == distanceOption
        
        Button {
          viewModel.searchDistanceOption = distanceOption
          isRefreshButtonShown = true
          UISelectionFeedbackGenerator().selectionChanged()
        } label: {
          Text(distanceOption.displayName)
            .font(.pretendard(size: 13, weight: .semiBold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 10)
            .background {
              if isSelectedDistance {
                Capsule()
                  .fill(isSelectedDistance ? DesignSystemAsset.black.swiftUIColor : Color.clear)
                  .matchedGeometryEffect(id: "distance_selector.background", in: namespace)
              }
            }
        }
      }
    }
    .padding(2)
    .background(DesignSystemAsset.gray70.swiftUIColor)
    .clipShape(Capsule())
    .animation(.snappy(duration: 0.35), value: viewModel.searchDistanceOption)
  }
  
  
  // MARK: - Private Methods
  
  private func showNoSearchResultView() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
    
    withAnimation {
      self.attempts += 1
      isNoResultViewShown = true
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      isNoResultViewShown = false
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(SearchCakeShopOnMapViewModel.self) { _ in
    let useCase = MockSearchLocatedCakeShopUseCase()
    return SearchCakeShopOnMapViewModel(useCase: useCase)
  }
  return SearchCakeShopOnMapView()
}
