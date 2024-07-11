//
//  TrendingCakeShopView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import Kingfisher

import DomainSearch

struct TrendingCakeShopView: View {
  
  // MARK: - Properties
  
  private let trendingCakeShop: CakeShop
  
  
  // MARK: - Initializers
  
  init(trendingCakeShop: CakeShop) {
    self.trendingCakeShop = trendingCakeShop
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        if let profileImageUrl = trendingCakeShop.profileImageUrl {
          KFImage(URL(string: profileImageUrl))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(52)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(Circle())
        } else {
          Circle()
            .fill(Color(hex: "FFA9DC"))
            .size(52)
            .overlay {
              DesignSystemAsset.cakeFaceTongue.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 42)
            }
        }
        
        VStack(spacing: 4) {
          Text(trendingCakeShop.name)
            .font(.pretendard(size: 15, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .lineLimit(1)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(trendingCakeShop.bio ?? "")
            .font(.pretendard(size: 12, weight: .regular))
            .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(2)
        }
      }
      
      VStack {
        HStack {
          imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 0])
            .size(152)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.topLeft])
          
          VStack {
            imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 1])
              .size(72)
              .roundedCorner(8, corners: .allCorners)
              .roundedCorner(12, corners: [.topRight])
            
            imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 2])
              .size(72)
              .roundedCorner(8, corners: .allCorners)
          }
        }
        
        HStack {
          imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 3])
            .size(72)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.bottomLeft])
          
          imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 4])
            .size(72)
            .roundedCorner(8, corners: .allCorners)
          
          imageView(imageUrlString: trendingCakeShop.cakeImageUrls[safe: 5])
            .size(72)
            .roundedCorner(8, corners: .allCorners)
            .roundedCorner(12, corners: [.bottomRight])
        }
      }
      .frame(maxWidth: .infinity)
    }
    .contentShape(Rectangle())
    .padding(16)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
    }
    .frame(maxWidth: 264)
  }
  
  private func imageView(imageUrlString: String?) -> some View {
    KFImage(URL(string: imageUrlString ?? ""))
      .placeholder {
        DesignSystemAsset.gray10.swiftUIColor
          .overlay {
            DesignSystemAsset.cakePin.swiftUIImage
              .resizable()
              .scaledToFit()
              .frame(width: 36)
          }
      }
      .resizable()
      .aspectRatio(contentMode: .fill)
      .aspectRatio(1/1, contentMode: .fit)
      .clipShape(
        Rectangle()
      )
  }
}


// MARK: - Preview

import PreviewSupportCakeShop

#Preview {
  TrendingCakeShopView(trendingCakeShop: .init(
    shopId: 0,
    profileImageUrl: "https://static.printler.com/cache/5/7/0/b/1/1/570b115da3e90ff66fd59ff1645b64716caeca1d.jpg",
    name: "고양이네 케이크",
    bio: "고양이가 직접 만들어주는 츄르보다 맛있는 미친 케이크",
    cakeImageUrls: [
      "https://i.pinimg.com/736x/74/f4/f5/74f4f548392fbdafbe8a5d9764c83eaf.jpg",
      "https://i.pinimg.com/736x/b9/c4/7e/b9c47ef70bff06613d397abfce02c6e7.jpg",
      "https://ctl.s6img.com/society6/img/CnFTfKZu5-Aebu2t1YyEdwFKs4M/w_700/prints/~artwork/s6-original-art-uploads/society6/uploads/misc/5653cd36be88468b8387ee851c6e5cc0/~~/buff-cat-meme-prints.jpg",
      "https://i.etsystatic.com/33775099/r/il/1ddf70/5859199862/il_570xN.5859199862_ncc7.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbhNX2JN8eCqDEDkuN33jTXL7Uq-gEq0jMgA&usqp=CAU",
      "https://imgflip.com/s/meme/Smiling-Cat.jpg"
    ], workingDaysWithTime: []))
}
