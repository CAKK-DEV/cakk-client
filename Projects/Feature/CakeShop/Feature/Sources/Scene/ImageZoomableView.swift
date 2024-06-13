//
//  ImageZoomableView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

public struct ImageZoomableView: View {
  
  // MARK: - Properties
  
  private let imageUrl: String
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var imageOffset: CGPoint = .zero
  @State private var imageScale: CGFloat = 0
  @State private var imageScalePosition: CGPoint = .zero
  
  @State private var imageDragStartLocation: CGPoint = .zero
  @State private var imageDragCurrentLocation: CGPoint = .zero
  @State private var dragOffset: CGSize = .zero
  @State private var dragDistance: CGFloat = 0.0

  
  // MARK: - Initializers
  
  public init(imageUrl: String) {
    self.imageUrl = imageUrl
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Spacer()
          
          Button {
            dismiss()
          } label: {
            Circle()
              .fill(.white.opacity(0.15))
              .size(36)
              .overlay {
                Image(systemName: "xmark")
                  .font(.system(size: 15, weight: .semibold))
                  .foregroundStyle(.white)
              }
          }
        }
        
        Spacer()
      }
      .padding(20)
      
      AsyncImage(url: URL(string: imageUrl)) { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 22))
          .offset(x: imageOffset.x, y: imageOffset.y)
          .offset(dragOffset)
          .overlay {
            GeometryReader { proxy in
              let size = proxy.size
              ZoomGesture(size: size, scale: $imageScale, offset: $imageOffset, scalePosition: $imageScalePosition)
            }
          }
          .scaleEffect(1 + imageScale, anchor: .init(x: imageScalePosition.x, y: imageScalePosition.y))
          .scaleEffect(1 - dragDistance / 1000)
          .gesture(
            DragGesture()
              .onChanged { gesture in
                imageDragStartLocation = gesture.startLocation
                imageDragCurrentLocation = gesture.location
                
                dragDistance = imageDragStartLocation.distance(to: imageDragCurrentLocation)
                dragOffset = gesture.translation
                
                if dragDistance > 180 {
                  dismiss()
                }
              }
              .onEnded { _ in
                withAnimation(.smooth) {
                  dragOffset = .zero
                  dragDistance = 0
                }
              }
          )
      } placeholder: {
        ProgressView()
      }
      .padding(24)
    }
  }
}

private extension CGPoint {
  func distance(to point: CGPoint) -> CGFloat {
    let dx = point.x - self.x
    let dy = point.y - self.y
    return sqrt(dx*dx + dy*dy)
  }
}



// MARK: - Preview

#Preview {
  ImageZoomableView(imageUrl: "https://images.unsplash.com/photo-1621303837174-89787a7d4729?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D")
}
