//
//  OperationDayWithTimeDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain
import DomainSearch

struct OperationDayWithTimeDTO: Decodable {
  let operationDay: OperationDayDTO
  let operationStartTime: String
  let operationEndTime: String
}


// MARK: - Mapper

/// DTO -> Domain
extension OperationDayWithTimeDTO {
  func toDomain() -> WorkingDayWithTime {
    return .init(workingDay: self.operationDay.toDomain(),
                 startTime: self.operationStartTime,
                 endTime: self.operationEndTime)
  }
}

