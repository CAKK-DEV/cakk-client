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
  
  private let annotationItem: AnnotationItem
  public struct AnnotationItem: Identifiable {
    public var id: String { return "\(latitude)/\(longitude)" }
    public let shopName: String
    public let latitude: Double
    public let longitude: Double
    
    public init(shopName: String, latitude: Double, longitude: Double) {
      self.shopName = shopName
      self.latitude = latitude
      self.longitude = longitude
    }
  }
  
  @State private var region: MKCoordinateRegion
  @State private var isShowing = false
  
  
  // MARK: - Initializers
  
  public init(annotationItem: AnnotationItem) {
    self.annotationItem = annotationItem
    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotationItem.latitude, longitude: annotationItem.longitude),
                                     span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Map(coordinateRegion: $region, annotationItems: [annotationItem]) { item in
      let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
      return MapAnnotation(coordinate: coordinate) {
        VStack(spacing: 6) {
          DesignSystemAsset.shopMarkerLarge.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 46)
            .scaleEffect(isShowing ? 1.0 : 0)
            .offset(y: isShowing ? 0 : 20)
            .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1), value: isShowing)
          
          Text(item.shopName)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.black)
            .scaleEffect(isShowing ? 1.0 : 0.3)
            .opacity(isShowing ? 1.0 : 0.0)
            .offset(y: isShowing ? 0 : -16)
            .animation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 1).delay(0.375), value: isShowing)
        }
        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 4)
      }
    }
    .frame(height: 180)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    }
    .onFirstAppear {
      startMapAnimation()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func startMapAnimation() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      withAnimation {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotationItem.latitude, longitude: annotationItem.longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.0008, longitudeDelta: 0.000))
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        isShowing = true
      }
    }
  }
}


// MARK: - Preview

#Preview {
  let annotationItem = ShopLocationMapView.AnnotationItem(shopName: "케이크샵 이름", latitude: 37.514575, longitude: 127.0495556)
  return ShopLocationMapView(annotationItem: annotationItem)
    .padding()
}
