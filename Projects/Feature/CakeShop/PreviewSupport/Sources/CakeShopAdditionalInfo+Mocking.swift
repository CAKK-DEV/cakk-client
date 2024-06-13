//
//  CakeShopAdditionalInfo+Mocking.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopAdditionalInfo {
  static var mock: Self {
    .init(location: .init(address: "서울특별시 강남구 어쩌고로 72",
                          latitude: 37.514575,
                          longitude: 127.0495556),
          workingDaysWithTime: [
            .init(workingDay: .sun, startTime: "10:00:00", endTime: "22:00:00"),
            .init(workingDay: .tue, startTime: "10:00:00", endTime: "22:00:00"),
            .init(workingDay: .thu, startTime: "10:00:00", endTime: "22:00:00"),
            .init(workingDay: .fri, startTime: "10:00:00", endTime: "22:00:00"),
            .init(workingDay: .sat, startTime: "10:00:00", endTime: "22:00:00")
          ])
  }
}
