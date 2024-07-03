//
//  SearchCakeShopUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchCakeShopUseCase {
  func execute(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[CakeShop], Error>
}
