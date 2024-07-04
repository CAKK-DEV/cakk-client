//
//  SearchCakeShopOnMapView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/19/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import Kingfisher

import DomainSearch

import MapKit

import DIContainer
import Router

import LocationService

public struct SearchCakeShopOnMapView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: SearchCakeShopOnMapViewModel
  @EnvironmentObject private var router: Router
  
  @Namespace private var namespace
  @State private var isRefreshButtonShown = false
  
  @State private var dragOffset: CGSize = .zero

  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(SearchCakeShopOnMapViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  // MARK: - Views
  
  public var body: some View {
    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.locatedCakeShops) { shop in
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
        }
      }
    }
    .animation(.smooth)
    .ignoresSafeArea()
    .overlay {
      VStack(spacing: 0) {
        navigationBar()
        Spacer()
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 16)
    }
    .overlay {
      VStack(spacing: 0) {
        Spacer()
        cakeShopView(viewModel.selectedCakeShop)
          .padding(.horizontal, 14)
          .padding(.bottom, 16)
          .frame(maxWidth: 420)
          .scaleEffect(viewModel.selectedCakeShop == nil ? 0.65 : 1)
          .offset(x: dragOffset.width,  y: viewModel.selectedCakeShop == nil ? 500 : dragOffset.height)
          .animation(.snappy, value: viewModel.selectedCakeShop == nil)
      }
    }
    .gesture(
      DragGesture()
        .onChanged { _ in
          isRefreshButtonShown = true
        }
    )
    .onFirstAppear {
      viewModel.fetchLocatedCakeShops()
      
      if LocationService.shared.authorizationStatus == .notDetermined {
        LocationService.shared.requestLocationPermission()
      } else if LocationService.shared.authorizationStatus != .authorizedAlways
                  && LocationService.shared.authorizationStatus != .authorizedWhenInUse {
        DialogManager.shared.showDialog(.locationPermissionDenied(completion: {
          router.navigateBack()
        }))
      }
    }
    .onChange(of: viewModel.locatedCakeShopsFetchingState) { state in
      if state == .success {
        isRefreshButtonShown = false
      } else {
        isRefreshButtonShown = true
      }
    }
  }
  
  private func cakeShopView(_ cakeShop: LocatedCakeShop?) -> some View {
    VStack(spacing: 16) {
      HStack(alignment: .top, spacing: 12) {
        if let profileImageUrl = cakeShop?.profileImageUrl {
          KFImage(URL(string: profileImageUrl))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(72)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(Circle())
            .overlay {
              Circle()
                .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 0.5)
            }
        } else {
          Circle()
            .fill(DesignSystemAsset.gray10.swiftUIColor)
            .size(72)
        }
        
        VStack(spacing: 8) {
          Text(cakeShop?.name ?? "")
            .font(.pretendard(size: 17, weight: .bold))
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
        .padding(.vertical, 8)
      }
      
      HStack(spacing: 6) {
        ForEach(0..<4, id: \.self) { index in
          if let imageUrlString = cakeShop?.cakeImageUrls[safe: index] {
            RoundedRectangle(cornerRadius: 16)
              .overlay {
                KFImage(URL(string: imageUrlString))
                  .resizable()
                  .scaledToFill()
                  .frame(maxWidth: .infinity)
                  .background(DesignSystemAsset.gray10.swiftUIColor)
              }
              .aspectRatio(1/1, contentMode: .fit)
              .clipShape(RoundedRectangle(cornerRadius: 16))
          } else {
            DesignSystemAsset.gray10.swiftUIColor
              .aspectRatio(1/1, contentMode: .fit)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .overlay {
                DesignSystemAsset.cakePin.swiftUIImage
                  .resizable()
                  .scaledToFit()
                  .frame(width: 44)
                  .contentShape(Rectangle())
              }
          }
        }
      }
      .frame(maxWidth: .infinity)
    }
    .padding(16)
    .background(Color.white.ignoresSafeArea())
    .clipShape(RoundedRectangle(cornerRadius: 30))
    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 4)
    .gesture(DragGesture()
      .onChanged { gesture in
        withAnimation(.smooth) {
          dragOffset = gesture.translation
        }
      }
      .onEnded { gesture in
        withAnimation(.smooth) {
          dragOffset = .zero
        }
      }
    )
    .onTapGesture {
      if let shopId = cakeShop?.id {
        router.navigate(to: PublicSearchDestination.shopDetail(shopId: shopId))
      }
    }
  }
  
  private func navigationBar() -> some View {
    ZStack {
      // Refresh Button
      Button {
        viewModel.fetchLocatedCakeShops()
      } label: {
        let isLoading = viewModel.locatedCakeShopsFetchingState == .loading
        HStack(spacing: 12) {
          Text(isLoading ? "검색중" : "이 지역 재검색")
            .font(.pretendard(size: 15, weight: .semiBold))
            .foregroundStyle(isLoading ? .white.opacity(0.65) : .white)
          
          if isLoading {
            ProgressView()
              .tint(.white)
          }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
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
      
      // Back Button
      HStack {
        Button {
          router.navigateBack()
        } label: {
          ZStack {
            Circle()
              .fill(.white)
            
            Circle()
              .stroke(DesignSystemAsset.gray10.swiftUIColor, lineWidth: 1.5)
            
            Image(systemName: "arrow.left")
              .font(.system(size: 20, weight: .medium))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          }
          .size(48)
          .shadow(color: .black.opacity(0.25), radius: 20, y: 4)
        }
        .modifier(BouncyPressEffect())
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - Array Extension for Safe Indexing
// TODO: 공통 Util 모듈로 빼기

private extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
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
