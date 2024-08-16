//
//  SocialLoginSignOutUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 8/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SocialLoginSignOutUseCase {
  func execute() -> AnyPublisher<Void, Error>
}
