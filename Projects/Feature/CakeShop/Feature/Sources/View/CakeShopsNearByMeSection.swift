//
//  CakeShopsNearByMeSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import DomainCakeShop
import DomainSearch

import DIContainer

import MapKit
import LocationService

import LinkNavigator

struct CakeShopsNearByMeSection: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: CakeShopNearByMeViewModel
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeShopNearByMeViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 12) {
      SectionHeaderLarge(title: "내 근처 케이크샵",
                         description: "내 근처 \(viewModel.locatedCakeShops.count)개의 케이크샵이 발견되었어요!")
      .overlay {
        HStack {
          Image(systemName: "chevron.compact.right")
            .font(.system(size: 20))
            .padding(6)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.horizontal, 16)
      .onTapGesture {
        navigator?.next(paths: [RouteHelper.Map.path], items: [:], isAnimated: true)
      }
      
      Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.locatedCakeShops) { shop in
        let coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        return MapAnnotation(coordinate: coordinate) {
          DesignSystemAsset.shopMarkerRegular.swiftUIImage
            .resizable()
            .size(32)
        }
      }
      .disabled(true)
      .frame(height: 224)
      .blur(radius: (LocationService.shared.authorizationStatus != .authorizedWhenInUse
                     && LocationService.shared.authorizationStatus != .authorizedAlways) ? 20 : 0)
      .overlay {
        if LocationService.shared.authorizationStatus != .authorizedWhenInUse
            && LocationService.shared.authorizationStatus != .authorizedAlways {
          VStack(spacing: 24) {
            Text("위치 권한을 허용하여\n내 주변 케이크 샵을 찾아보세요!")
              .font(.pretendard(size: 15, weight: .medium))
              .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
              .shadow(radius: 12)
              .multilineTextAlignment(.center)
            
            CKButtonCompact(title: "위치 권한 요청") {
              if LocationService.shared.authorizationStatus == .notDetermined {
                LocationService.shared.requestLocationPermission()
              } else {
                DialogManager.shared.showDialog(.locationPermissionDenied(completion: nil))
              }
            }
          }
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.gray.opacity(0.2), lineWidth: 1)
      }
      .padding(.horizontal, 16)
      .animation(.smooth)
    }
    .onFirstAppear {
      viewModel.fetchLocatedCakeShops()
    }
    .onChange(of: LocationService.shared.authorizationStatus) { permissionState in
      /// 권한 요청 완료 후에 데이터를 불러옵니다.
      switch permissionState {
      case .authorizedAlways, .authorizedWhenInUse:
        viewModel.fetchLocatedCakeShops()
      default:
        viewModel.fetchLocatedCakeShops()
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopNearByMeViewModel.self) { _ in
    let useCase = MockSearchLocatedCakeShopUseCase()
    return CakeShopNearByMeViewModel(useCase: useCase)
  }
  return CakeShopsNearByMeSection()
}
