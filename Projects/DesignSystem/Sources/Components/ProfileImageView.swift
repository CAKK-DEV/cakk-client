//
//  ProfileImageView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import Kingfisher

public struct ProfileImageView: View {
  
  // MARK: - Properties
  
  private let imageUrlString: String?
  
  
  // MARK: - Initializers
  
  public init(imageUrlString: String? = nil) {
    self.imageUrlString = imageUrlString
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Circle()
      .fill(Color.white)
      .frame(width: 128, height: 128)
      .overlay {
        if let imageUrlString {
          KFImage(URL(string: imageUrlString))
            .placeholder { defaultImage() }
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .padding(3)
        } else {
          defaultImage()
            .padding(3)
        }
      }
      .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
  }
  
  private func defaultImage() -> some View {
    Circle()
      .fill(Color(hex: "FFA9DC"))
      .overlay {
        DesignSystemAsset.cakeFaceTongue.swiftUIImage
          .resizable()
          .size(96)
      }
  }
}


// MARK: - Preview

#Preview {
  let imageURLString = "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=1743&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  
  return VStack {
    ProfileImageView(imageUrlString: imageURLString)
    ProfileImageView()
  }
}
