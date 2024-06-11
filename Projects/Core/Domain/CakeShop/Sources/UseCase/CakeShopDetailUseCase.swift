//
//  CakeShopDetailUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeShopDetailUseCase {
  func execute(shopId: Int) -> AnyPublisher<CakeShopDetail, CakeShopDetailError>
}
