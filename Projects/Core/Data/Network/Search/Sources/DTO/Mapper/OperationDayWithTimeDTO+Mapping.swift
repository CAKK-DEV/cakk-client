//
//  OperationDayWithTimeDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch

extension OperationDayWithTimeDTO {
  func toDomain() -> WorkingDayWithTime {
    return .init(workingDay: self.operationDay.toDomain(),
                 startTime: self.operationStartTime,
                 endTime: self.operationEndTime)
  }
}

