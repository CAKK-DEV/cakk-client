//
//  TrendingSearchKeywordUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol TrendingSearchKeywordUseCase {
  func execute(count: Int) -> AnyPublisher<[String], Error>
}
