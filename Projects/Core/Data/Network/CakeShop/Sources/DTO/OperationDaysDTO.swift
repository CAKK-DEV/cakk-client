//
//  OperationDaysDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import CommonDomain
import DomainCakeShop

public struct OperationDaysDTO: Encodable {
  let operationDays: [OperationDayWithTimeDTO]
}


// MARK: - Mapper

/// DTO -> Domain
extension OperationDayWithTimeDTO {
  func toDomain() -> WorkingDayWithTime {
    .init(workingDay: self.operationDay.toDomain(),
          startTime: self.operationStartTime,
          endTime: self.operationEndTime)
  }
}
