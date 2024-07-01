//
//  NewCakeShopBasicInfo.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit

public struct NewCakeShopBasicInfo {
  public var profileImage: ProfileImage
  public var shopName: String
  public var shopBio: String
  public var shopDescription: String
  
  public init(
    profileImage: ProfileImage,
    shopName: String,
    shopBio: String,
    shopDescription: String
  ) {
    self.profileImage = profileImage
    self.shopName = shopName
    self.shopBio = shopBio
    self.shopDescription = shopDescription
  }
  
  public enum ProfileImage: Equatable {
    /// 기존 프로필 이미지를 삭제하고싶은 경우
    case delete
    
    /// 새로운 프로필 이미지
    case new(image: UIImage)
    
    /// 기존에 이미지가 있는 경우
    case original(imageUrl: String)
    
    /// 기존에 이미지가 없는 경우
    case none
  }
}
