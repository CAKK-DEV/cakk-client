//
//  PlainButtonStyle.swift
//  CAKK
//
//  Created by 이승기 on 5/5/24.
//

import SwiftUI

/// SwiftUI 기본 press opacity effect 없애주는 역할
public struct PlainButtonStyle: ButtonStyle {
  public func makeBody(configuration: Configuration) -> some View {
    return configuration.label
  }
}

extension View {
  func disableDefaultPressEffect() -> some View {
    return self.buttonStyle(PlainButtonStyle())
  }
}


// MARK: - Preview

#Preview {
  Button {
    // no action
  } label: {
    Text("title")
      .frame(minWidth: 120)
  }
  .buttonStyle(CAKKButtonStyle_Large())
  .buttonStyle(PlainButtonStyle())
}
