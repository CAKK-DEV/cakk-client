//
//  View+CAKKLargeButtonShadow.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public extension View {
  func largeButtonShadow() -> some View {
    self.shadow(color: .black.opacity(0.25), radius: 12, y: 2)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Button {
      // no action
    } label: {
      Text("title")
        .frame(width: 120)
    }
    .buttonStyle(CAKKButtonStyle_Large())
    .largeButtonShadow()
  }
}
