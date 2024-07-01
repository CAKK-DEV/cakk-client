//
//  EditShopBasicInfoUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol EditShopBasicInfoUseCase {
  func execute(cakeShopId: Int, newCakeShopBasicInfo: NewCakeShopBasicInfo) -> AnyPublisher<Void, CakeShopError>
}
