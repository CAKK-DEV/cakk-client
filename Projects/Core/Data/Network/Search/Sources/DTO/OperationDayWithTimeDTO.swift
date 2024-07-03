//
//  OperationDayWithTimeDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct OperationDayWithTimeDTO: Decodable {
  let operationDay: OperationDayDTO
  let operationStartTime: String
  let operationEndTime: String
}
