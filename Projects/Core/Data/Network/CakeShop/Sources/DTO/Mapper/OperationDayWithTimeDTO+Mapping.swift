//
//  OperationDayWithTimeDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension OperationDayWithTimeDTO {
  func toDomain() -> WorkingDayWithTime {
    .init(workingDay: self.operationDay.toDomain(),
          startTime: self.operationStartTime,
          endTime: self.operationEndTime)
  }
}