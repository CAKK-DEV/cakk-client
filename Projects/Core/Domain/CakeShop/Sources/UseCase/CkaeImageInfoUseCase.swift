//
//  CakeShopQuickInfoUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeShopQuickInfoUseCase {
  func execute(shopId: Int, cakeImageId: Int?) -> AnyPublisher<CakeShopQuickInfo, Error>
}
