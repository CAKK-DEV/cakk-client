//
//  WorkingDaysWithTime+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import CommonDomain
import DomainCakeShop

extension Array where Element == WorkingDayWithTime {
  func toDTO() -> OperationDaysDTO {
    OperationDaysDTO(operationDays: self.map { $0.toDTO() })
  }
}
