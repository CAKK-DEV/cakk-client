//
//  OperationDaysDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

public struct OperationDaysDTO: Encodable {
  let operationDays: [OperationDayWithTimeDTO]
}
