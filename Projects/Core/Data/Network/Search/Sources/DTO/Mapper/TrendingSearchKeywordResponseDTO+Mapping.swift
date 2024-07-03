//
//  TrendingSearchKeywordResponseDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

extension TrendingSearchKeywordResponseDTO {
  func toDomain() -> [String] {
    return self.data.keywordList
  }
}
