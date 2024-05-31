//
//  Date+Mapping.swift
//  NetworkPlatform
//
//  Created by 이승기 on 5/12/24.
//

import Foundation

extension Date {
  public func toDTO() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: self)
  }
}
