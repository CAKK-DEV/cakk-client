//
//  CakeImagesByShopIdUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain

public protocol CakeImagesByShopIdUseCase {
  func execute(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
}