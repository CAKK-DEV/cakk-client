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
  func updateUserProfile(profileImageUrl: String?, nickName: String, email: String, gender: Gender, birthday: Date?, accessToken: String) -> AnyPublisher<Void, UserProfileError>
  func withdraw(accessToken: String) -> AnyPublisher<Void, UserProfileError>
  func fetchMyCakeShopId(accessToken: String) -> AnyPublisher<Int?, UserProfileError>
}
