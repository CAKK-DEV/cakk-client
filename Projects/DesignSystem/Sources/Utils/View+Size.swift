//
//  View+Size.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public extension View {
  func size(_ value: CGFloat) -> some View {
    self.frame(width: value, height: value)
  }
}
