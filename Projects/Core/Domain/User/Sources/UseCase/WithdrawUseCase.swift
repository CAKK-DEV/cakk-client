//
//  WithdrawUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol WithdrawUseCase {
  func execute() -> AnyPublisher<Void, UserProfileError>
}
