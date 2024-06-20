//
//  TrendingCakeShopsUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/20/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol TrendingCakeShopsUseCase {
  func execute() -> AnyPublisher<[TrendingCakeShop], Error>
}
