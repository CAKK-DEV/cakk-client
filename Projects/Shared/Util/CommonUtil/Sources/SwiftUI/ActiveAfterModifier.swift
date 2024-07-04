//
//  a.swift
//  CommonUtil
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public extension View {
  func activeAfter(_ duration: TimeInterval) -> some View {
    ModifiedContent(content: self, modifier: ActiveAfterModifier(duration: duration))
  }
}

struct ActiveAfterModifier: ViewModifier {
  @State private var isDisabled = true
  let duration: TimeInterval
  
  func body(content: Content) -> some View {
    content
      .disabled(isDisabled)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
          isDisabled = false
        }
      }
  }
}
