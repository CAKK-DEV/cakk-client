//
//  ShopLocationMapView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil

import MapKit

public struct ShopLocationMapView: View {
  
  // MARK: - Properties
  
  private let shopName: String
  private let latitude: Double
  private let longitude: Double
  @State private var region: MKCoordinateRegion
  
  @State private var isShowing = false
  
  
  // MARK: - Initializers
  
  public init(
    shopName: String,
    latitude:Double,
    longitude: Double
  ) {
    self.shopName = shopName
    self.latitude = latitude
    self.longitude = longitude
    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                     span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Map(coordinateRegion: $region)
      .frame(height: 180)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.gray.opacity(0.2), lineWidth: 1)
      }
      .overlay {
        VStack(spacing: 6) {
          DesignSystemAsset.shopMarkerLarge.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 46)
            .scaleEffect(isShowing ? 1.0 : 0)
            .offset(y: isShowing ? 0 : 20)
            .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1), value: isShowing)
          
          Text(shopName)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.black)
            .scaleEffect(isShowing ? 1.0 : 0.3)
            .opacity(isShowing ? 1.0 : 0.0)
            .offset(y: isShowing ? 0 : -16)
            .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1).delay(0.375), value: isShowing)
        }
        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 4)
      }
      .disabled(true)
      .onFirstAppear {
        startMapAnimation()
      }
  }
  
  
  // MARK: - Private Methods
  
  private func startMapAnimation() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      withAnimation {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        isShowing = true
      }
    }
  }
}


// MARK: - Preview

#Preview {
  ShopLocationMapView(shopName: "케이크샵 이름", latitude: 37.514575, longitude: 127.0495556)
    .padding()
}
