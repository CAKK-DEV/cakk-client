//
//  EditCakeImageUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain

public protocol EditCakeImageUseCase {
  func execute(cakeImageId: Int, imageUrl: String, categories: [CakeCategory], tags: [String]) -> AnyPublisher<Void, CakeShopError>
}
