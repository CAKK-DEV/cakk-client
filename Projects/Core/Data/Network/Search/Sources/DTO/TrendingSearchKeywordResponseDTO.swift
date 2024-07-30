//
//  TrendingSearchKeywordResponseDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct TrendingSearchKeywordResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let keywordList: [String]
    let totalCount: Int
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension TrendingSearchKeywordResponseDTO {
  func toDomain() -> [String] {
    return self.data.keywordList
  }
}
