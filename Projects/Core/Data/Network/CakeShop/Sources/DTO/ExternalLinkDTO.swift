//
//  ExternalLinkDTO.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

struct ExternalLinkDTO: Decodable {
  let linkKind: LinkKind
  let linkPath: String
  
  enum LinkKind: String, Decodable {
    case web = "WEB"
    case insta = "INSTAGRAM"
    case kakao = "KAKAOTALK"
  }
}