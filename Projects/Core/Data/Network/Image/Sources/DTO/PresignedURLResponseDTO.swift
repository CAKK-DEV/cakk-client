//
//  PresignedURLResponseDTO.swift
//  NetworkImage
//
//  Created by 이승기 on 7/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct PresignedUrlResponseDTO: Decodable {
  let returnCode: String
  let returnMessage: String
  let data: Data
  
  struct Data: Decodable {
    let imagePath: String
    let imageUrl: String
    let presignedUrl: String
  }
}
