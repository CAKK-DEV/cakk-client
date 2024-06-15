//
//  SearchRepository.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchRepository {
  func fetchTrendingSearchKeywords(count: Int) -> AnyPublisher<[String], Error>
}
