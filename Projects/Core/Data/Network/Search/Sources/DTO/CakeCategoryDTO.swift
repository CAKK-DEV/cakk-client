//
//  CakeCategoryDTO.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CommonDomain

public enum CakeCategoryDTO: String, Codable {
  case threeDimensional = "THREE_DIMENSIONAL"
  case character = "CHARACTER"
  case photo = "PHOTO"
  case lunchbox = "LUNCHBOX"
  case figure = "FIGURE"
  case flower = "FLOWER"
  case lettering = "LETTERING"
  case riceCake = "RICE_CAKE"
  case tiara = "TIARA"
  case etc = "ETC"
}


// MARK: - Mapper

/// Domain -> DTO
extension CakeCategory {
  func toDTO() -> CakeCategoryDTO {
    switch self {
    case .threeDimensional:
      return .threeDimensional
    case .character:
      return .character
    case .photo:
      return .photo
    case .lunchbox:
      return .lunchbox
    case .figure:
      return .figure
    case .flower:
      return .flower
    case .lettering:
      return .lettering
    case .riceCake:
      return .riceCake
    case .tiara:
      return .tiara
    case .etc:
      return .etc
    }
  }
}
