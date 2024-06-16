//
//  SearchHistory.swift
//  DomainSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct SearchHistory: Identifiable, Equatable, Codable {
  public let id: UUID
  public let keyword: String
  public var date: Date
  
  public init(
    keyword: String,
    date: Date = Date()
  ) {
    self.id = UUID()
    self.keyword = keyword
    self.date = date
  }
}
