//
//  CakeShopThumbnailView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/19/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil

public struct CakeShopThumbnailView: View {
  
  // MARK: - Properties
  
  private let shopName: String
  private let shopBio: String
  private let workingDays: [WorkingDay]
  private let profileImageUrl: String
  private let cakeImageUrls: [String]
  
  public enum WorkingDay: CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var displayName: String {
      switch self {
      case .sun:
        return "일"
      case .mon:
        return "월"
      case .tue:
        return "화"
      case .wed:
        return "수"
      case .thu:
        return "목"
      case .fri:
        return "금"
      case .sat:
        return "토"
      }
    }
  }
  
  
  // MARK: - Initializers
  
  
  public init(
    shopName: String,
    shopBio: String,
    workingDays: [WorkingDay],
    profileImageUrl: String,
    cakeImageUrls: [String]
  ) {
    self.shopName = shopName
    self.shopBio = shopBio
    self.workingDays = workingDays
    self.profileImageUrl = profileImageUrl
    self.cakeImageUrls = cakeImageUrls
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 12) {
        AsyncImage(url: URL(string: profileImageUrl)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(64)
            .clipShape(Circle())
            .overlay {
              Circle()
                .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
            }
        } placeholder: {
          Circle()
            .fill(DesignSystemAsset.gray10.swiftUIColor)
            .size(64)
        }

        VStack(spacing: 6) {
          VStack(spacing: 2) {
            Text(shopName)
              .font(.pretendard(size: 16, weight: .medium))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
            
            Text(shopBio)
              .font(.pretendard(size: 12, weight: .regular))
              .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(2)
          }
          
          HStack(spacing: 2) {
            ForEach(WorkingDay.allCases, id: \.self) { workingDay in
              Text(workingDay.displayName)
                .font(.pretendard(size: 12))
                .foregroundStyle(workingDays.contains(workingDay)
                                 ? Color(hex: "FF5CBE")
                                 : DesignSystemAsset.gray40.swiftUIColor )
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      
      HStack(spacing: 6) {
        ForEach(cakeImageUrls, id: \.self) { cakeImageUrl in
          AsyncImage(url: URL(string: cakeImageUrl)) { image in
            image
              .resizable()
              .aspectRatio(1/1, contentMode: .fit)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          } placeholder: {
            RoundedRectangle(cornerRadius: 8)
              .fill(DesignSystemAsset.gray10.swiftUIColor)
              .aspectRatio(1/1, contentMode: .fit)
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
    .padding(.top, 18)
    .padding(.bottom, 16)
    .padding(.horizontal, 16)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
    }
  }
}

#Preview {
  CakeShopThumbnailView(
    shopName: "미쁘다 케이크",
    shopBio: "미쁘다케이크🍰_레터링케이크 주문제작케이크 남양주레터링케이크 커스텀케이크 케이크",
    workingDays: [.sun, .mon, .tue, .wed, .thu],
    profileImageUrl: "https://pbs.twimg.com/media/F-qHHfbasAAr_jj.jpg",
    cakeImageUrls: [
      "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?q=80&w=1350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://plus.unsplash.com/premium_photo-1671212748162-d7bdb9d4f5ec?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D",
      "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D"
    ]
  )
}
