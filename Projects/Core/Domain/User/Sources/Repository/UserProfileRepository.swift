//
//  UserProfileRepository.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

public protocol UserProfileRepository {
  func fetchUserProfile(accessToken: String) -> AnyPublisher<UserProfile, UserProfileError>
  func updateUserProfile(newUserProfile: NewUserProfile, accessToken: String) -> AnyPublisher<Void, UserProfileError>
  func withdraw(accessToken: String) -> AnyPublisher<Void, UserProfileError>
  func requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, UserProfileError>
}
