//
//  TrendingCakeShopUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol TrendingCakeShopsUseCase {
  func execute() -> AnyPublisher<[CakeShop], Error>
}
