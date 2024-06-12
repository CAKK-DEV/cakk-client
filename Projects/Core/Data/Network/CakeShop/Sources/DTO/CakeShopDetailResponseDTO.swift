//
//  CakeShopDetailResponseDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import DomainCakeShop

struct CakeShopDetailResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data?
  
  struct Data: Decodable {
    let cakeShopId: String
    let cakeShopName: String
    let thumbnailUrl: String?
    var cakeShopBio: String
    var cakeShopDescription: String
    var operationDays: [OperationDayDTO]
    var links: [ExternalLinkDTO]
  }
}