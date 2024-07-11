//
//  Array+SafeIndexing.swift
//  CommonUtil
//
//  Created by 이승기 on 7/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
