//
//  CakeShopAdditionalInfoDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

struct CakeShopAdditionalInfoDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let shopAddress: String
    let latitude: Double
    let longitude: Double
    let shopOperationDays: [OperationDayWithTimeDTO]
  }
}


// MARK: - Mapper

/// DTO -> Domain
extension CakeShopAdditionalInfoDTO.Data {
  func toDomain() -> CakeShopAdditionalInfo {
    .init(location: .init(address: self.shopAddress,
                          latitude: self.latitude,
                          longitude: self.longitude),
          workingDaysWithTime: self.shopOperationDays.map { $0.toDomain() })
  }
}
