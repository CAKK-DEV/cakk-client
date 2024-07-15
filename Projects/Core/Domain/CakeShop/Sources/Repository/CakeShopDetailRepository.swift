//
//  CakeShopDetailRepository.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol CakeShopDetailRepository {
  func fetch(shopId: Int) -> AnyPublisher<CakeShopDetail, CakeShopDetailError>
  func fetchAdditionalInfo(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, Error>
  func isOwned(shopId: Int, accessToken: String) -> AnyPublisher<Bool, CakeShopError>
}
