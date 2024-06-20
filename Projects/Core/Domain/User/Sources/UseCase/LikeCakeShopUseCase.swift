//
//  LikeCakeShopUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol LikeCakeShopUseCase {
  func fetchLikedCakeShops(lastShopId: Int?, pageSize: Int) -> AnyPublisher<[LikedCakeShop], LikeError>
  func likeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError>
  func unlikeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError>
  func fetchCakeShopLikedState(shopId: Int) -> AnyPublisher<Bool, LikeError>
}
