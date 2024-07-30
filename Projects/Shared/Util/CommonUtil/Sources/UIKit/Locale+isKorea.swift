//
//  Locale+isKorea.swift
//  CommonUtil
//
//  Created by 이승기 on 7/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public extension Locale {
  static var isKorea: Bool {
    Self.current.region?.identifier == "KR"
  }
}
