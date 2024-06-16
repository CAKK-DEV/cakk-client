//
//  CakeShopView.swift
//  FeatureSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DomainSearch

struct CakeShopView: View {
  
  // MARK: - Properties
  
  private let cakeShop: CakeShop
  
  
  // MARK: - Initializers
  
  
  init(cakeShop: CakeShop) {
    self.cakeShop = cakeShop
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 12) {
        AsyncImage(url: URL(string: cakeShop.profileImageUrl)) { image in
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
            Text(cakeShop.name)
              .font(.pretendard(size: 16, weight: .medium))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
            
            Text(cakeShop.bio)
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
                .foregroundStyle(cakeShop.workingDaysWithTime.map { $0.workingDay }.contains(workingDay)
                                 ? Color(hex: "FF5CBE")
                                 : DesignSystemAsset.gray40.swiftUIColor )
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      
      HStack(spacing: 6) {
        ForEach(cakeShop.cakeImageUrls, id: \.self) { cakeImageUrl in
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
  CakeShopView(cakeShop: CakeShop(shopId: 0,
                                  profileImageUrl: "https://pbs.twimg.com/media/F-qHHfbasAAr_jj.jpg",
                                  name: "미쁘다 케이크",
                                  bio: "미쁘다케이크🍰_레터링케이크 주문제작케이크 남양주레터링케이크 커스텀케이크 케이크",
                                  cakeImageUrls: [
                                    "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?q=80&w=1350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    "https://plus.unsplash.com/premium_photo-1671212748162-d7bdb9d4f5ec?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D",
                                    "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D"
                                  ],
                                  workingDaysWithTime: [
                                    WorkingDayWithTime(workingDay: .sun, startTime: "10:00:00", endTime: "17:00:00"),
                                    WorkingDayWithTime(workingDay: .mon, startTime: "10:00:00", endTime: "17:00:00"),
                                    WorkingDayWithTime(workingDay: .tue, startTime: "10:00:00", endTime: "17:00:00"),
                                    WorkingDayWithTime(workingDay: .wed, startTime: "10:00:00", endTime: "17:00:00"),
                                    WorkingDayWithTime(workingDay: .thu, startTime: "10:00:00", endTime: "17:00:00")
                                  ]))
}
