//
//  CakeImagesByCategoryRepository.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeImagesByCategoryRepository {
  func fetch(category: CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
}
