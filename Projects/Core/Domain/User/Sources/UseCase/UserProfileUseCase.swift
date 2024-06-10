//
//  UserProfileUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol UserProfileUseCase {
  func execute() -> AnyPublisher<UserProfile, UserProfileError>
}
