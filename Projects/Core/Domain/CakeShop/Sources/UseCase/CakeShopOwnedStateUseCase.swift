//
//  CakeShopOwnedStateUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeShopOwnedStateUseCase {
  func execute(shopId: Int) -> AnyPublisher<Bool, CakeShopError>
}
