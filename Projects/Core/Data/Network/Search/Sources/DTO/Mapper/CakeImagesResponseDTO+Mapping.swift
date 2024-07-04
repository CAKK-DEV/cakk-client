//
//  CakeImagesResponseDTO+Mapping.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

extension CakeImagesResponseDTO {
  func toDomain() -> [CakeImage] {
    self.data.cakeImages.map { $0.toDomain() }
  }
}
