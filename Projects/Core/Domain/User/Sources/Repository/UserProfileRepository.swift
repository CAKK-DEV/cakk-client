//
//  UserProfileRepository.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol UserProfileRepository {
  func fetchUserProfile(accessToken: String) -> AnyPublisher<UserProfile, UserProfileError>
  func updateUserProfile(newUserProfile: NewUserProfile, accessToken: String) -> AnyPublisher<Void, UserProfileError>
  func withdraw(accessToken: String) -> AnyPublisher<Void, UserProfileError>
}
