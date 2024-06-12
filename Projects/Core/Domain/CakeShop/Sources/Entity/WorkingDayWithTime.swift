//
//  WorkingDayWithTime.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct WorkingDayWithTime {
  public var workingDay: WorkingDay
  public var startTime: String
  public var endTime: String
  
  public init(
    workingDay: WorkingDay,
    startTime: String,
    endTime: String
  ) {
    self.workingDay = workingDay
    self.startTime = startTime
    self.endTime = endTime
  }
}
