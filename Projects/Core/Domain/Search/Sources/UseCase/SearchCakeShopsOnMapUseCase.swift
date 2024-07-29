//
//  SearchLocatedCakeShopUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchLocatedCakeShopUseCase {
  func execute(distance: Int, longitude: Double, latitude: Double) -> AnyPublisher<[LocatedCakeShop], Error>
}
