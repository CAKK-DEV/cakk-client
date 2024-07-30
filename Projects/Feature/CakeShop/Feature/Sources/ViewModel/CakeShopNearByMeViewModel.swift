//
//  CakeShopNearByMeViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainSearch

import MapKit
import LocationService

public final class CakeShopNearByMeViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var locatedCakeShops: [LocatedCakeShop] = []
  private let useCase: SearchLocatedCakeShopUseCase
  @Published private(set) var locatedCakeShopsFetchingState: LocatedCakeShopsFetchingState = .idle
  enum LocatedCakeShopsFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LocationService.defaultCoordinates.latitude,
                                                                            longitude: LocationService.defaultCoordinates.longitude),
                                             span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(useCase: SearchLocatedCakeShopUseCase) {
    self.useCase = useCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchLocatedCakeShops() {
    /// 위치 권한이 허용되어있지 않는 경우 검색하지 않습니다.
    if LocationService.shared.authorizationStatus != .authorizedWhenInUse
        && LocationService.shared.authorizationStatus != .authorizedAlways {
      return
    }
    
    /// 현재 내 위치로 이동
    if let userLocation = LocationService.shared.userLocation {
      region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude),
                                  span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    useCase.execute(distance: 2000, /// 단위는 미터 입니다
                    longitude: region.center.longitude,
                    latitude: region.center.latitude)
    .subscribe(on: DispatchQueue.global())
    .receive(on: DispatchQueue.main)
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.locatedCakeShopsFetchingState = .failure
        print(error.localizedDescription)
      } else {
        self?.locatedCakeShopsFetchingState = .success
        self?.updateRegion()
      }
    } receiveValue: { [weak self] locatedCakeShops in
      self?.locatedCakeShops = locatedCakeShops
    }
    .store(in: &cancellables)
  }
  
  
  // MARK: - Private Methods
  
  private func updateRegion() {
    guard let firstShop = locatedCakeShops.first else { return }
    
    let minLatitude = locatedCakeShops.map { $0.latitude }.min() ?? firstShop.latitude
    let maxLatitude = locatedCakeShops.map { $0.latitude }.max() ?? firstShop.latitude
    let minLongitude = locatedCakeShops.map { $0.longitude }.min() ?? firstShop.longitude
    let maxLongitude = locatedCakeShops.map { $0.longitude }.max() ?? firstShop.longitude
    
    let centerLatitude = (minLatitude + maxLatitude) / 2
    let centerLongitude = (minLongitude + maxLongitude) / 2
    
    let latitudeDelta = (maxLatitude - minLatitude) * 1.5 /// 패딩
    let longitudeDelta = (maxLongitude - minLongitude) * 1.5 /// 패딩
    
    self.region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
      span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    )
  }
}
