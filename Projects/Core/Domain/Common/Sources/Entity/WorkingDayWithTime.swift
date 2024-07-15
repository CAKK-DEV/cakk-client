//
//  WorkingDayWithTime.swift
//  CommonDomain
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct WorkingDayWithTime: Equatable, Hashable {
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
