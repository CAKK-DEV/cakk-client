//
//  NewCakeShopDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public struct NewCakeShopDTO: Encodable {
  let businessNumber: String?
  let operationDays: [OperationDayWithTimeDTO]
  let shopName: String
  let shopBio: String?
  let shopDescription: String?
  let shopAddress: String
  let latitude: Double
  let longitude: Double
  let links: [ExternalLinkDTO]
}
