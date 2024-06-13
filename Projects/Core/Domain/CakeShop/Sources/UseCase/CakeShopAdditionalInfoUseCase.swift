//
//  CakeShopAdditionalInfoUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeShopAdditionalInfoUseCase {
  func execute(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, Error>
}
