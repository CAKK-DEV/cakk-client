//
//  CakeImageDetailUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeImageDetailUseCase {
  func execute(cakeImageId: Int) -> AnyPublisher<CakeImageDetail, CakeShopError>
}
