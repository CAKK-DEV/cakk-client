//
//  CakeShopError.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum CakeShopError: Error {
  case sessionExpired
  case imageUploadFailure
  case failure
}
