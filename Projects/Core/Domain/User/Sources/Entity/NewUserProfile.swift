//
//  NewUserProfile.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import UIKit

public struct NewUserProfile {
  public var profileImage: ProfileImage
  public var nickname: String
  public var email: String
  public var gender: Gender
  public var birthday: Date?
  
  public init(
    profileImage: ProfileImage,
    nickname: String,
    email: String,
    gender: Gender,
    birthday: Date? = nil
  ) {
    self.profileImage = profileImage
    self.nickname = nickname
    self.email = email
    self.gender = gender
    self.birthday = birthday
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
