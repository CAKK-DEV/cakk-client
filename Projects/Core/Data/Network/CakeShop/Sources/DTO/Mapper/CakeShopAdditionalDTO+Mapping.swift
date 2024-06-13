//
//  CakeShopAdditionalDTO+Mapping.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopAdditionalInfoDTO.Data {
  func toDomain() -> CakeShopAdditionalInfo {
    .init(location: .init(address: self.shopAddress,
                          latitude: self.latitude,
                          longitude: self.longitude),
          workingDaysWithTime: self.shopOperationDays.map { $0.toDomain() })
  }
}
