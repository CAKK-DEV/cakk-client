//
//  OnFirstAppear.swift
//  CommonUtil
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {
  @State private var hasAppeared = false
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        if !hasAppeared {
          hasAppeared = true
          action()
        }
      }
  }
}

public extension View {
  func onFirstAppear(perform action: @escaping () -> Void) -> some View {
    self.modifier(OnFirstAppearModifier(action: action))
  }
}
