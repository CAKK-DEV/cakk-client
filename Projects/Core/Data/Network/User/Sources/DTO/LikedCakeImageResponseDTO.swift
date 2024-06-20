//
//  LikedCakeImageResponseDTO.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct LikedCakeImagesResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let cakeImages: [LikedCakeImageDTO]
    let lastCakeHeartId: Int
    let size: Int
  }
}