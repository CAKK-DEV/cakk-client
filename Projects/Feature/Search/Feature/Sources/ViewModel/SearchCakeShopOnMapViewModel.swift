//
//  SearchCakeShopOnMapViewModel.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/19/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine
import MapKit
import LocationService

import DomainSearch

public final class SearchCakeShopOnMapViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var locatedCakeShops: [LocatedCakeShop] = []
  @Published var selectedCakeShop: LocatedCakeShop?
  private let useCase: SearchLocatedCakeShopUseCase
  @Published private(set) var locatedCakeShopsFetchingState: LocatedCakeShopsFetchingState = .idle
  enum LocatedCakeShopsFetchingState {
    case idle
    case loading
    case failure
    case success
  }
  
  @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LocationService.shared.userLocation?.latitude ?? LocationService.defaultCoordinates.latitude,
                                                                            longitude: LocationService.shared.userLocation?.longitude ?? LocationService.defaultCoordinates.longitude),
                                             span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  
  @Published var searchDistanceOption = SearchDistanceOption.allCases.first!

  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(useCase: SearchLocatedCakeShopUseCase) {
    self.useCase = useCase
    
    LocationService.shared.startUpdatingLocation()
  }
  
  
  // MARK: - Public Methods
  
  public func fetchLocatedCakeShops() {
    /// 위치 권한이 허용되어있지 않는 경우 검색하지 않습니다.
    if LocationService.shared.authorizationStatus != .authorizedWhenInUse
        && LocationService.shared.authorizationStatus != .authorizedAlways {
      return
    }
    
    locatedCakeShopsFetchingState = .loading
    
    useCase.execute(distance: searchDistanceOption.distance,
                    longitude: region.center.longitude,
                    latitude: region.center.latitude)
    .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
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
  
  public func setSelected(cakeShop: LocatedCakeShop) {
    selectedCakeShop = cakeShop
  }
  
  public func moveToUserLocation() {
    guard let userLocation = LocationService.shared.userLocation else { return }
    
    self.region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude),
      span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
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
