//
//  MyShopIdUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol MyShopIdUseCase {
  func execute() -> AnyPublisher<Int?, UserProfileError>
}
