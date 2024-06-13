//
//  CakeShopAdditionalInfo.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct CakeShopAdditionalInfo {
  public var location: CakeShopLocation
  public var workingDaysWithTime: [WorkingDayWithTime]
  
  public init(
    location: CakeShopLocation,
    workingDaysWithTime: [WorkingDayWithTime]
  ) {
    self.location = location
    self.workingDaysWithTime = workingDaysWithTime
  }
}
