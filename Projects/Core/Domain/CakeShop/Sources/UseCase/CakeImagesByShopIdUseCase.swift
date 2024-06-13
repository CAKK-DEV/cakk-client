//
//  CakeImagesByShopIdUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeImagesByShopIdUseCase {
  func execute(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
}
