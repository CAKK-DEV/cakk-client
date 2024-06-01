//
//  CAKKButtonStyle_Large.swift
//  CAKK
//
//  Created by 이승기 on 5/2/24.
//

import SwiftUI

public struct CAKKButtonStyle_Large: ButtonStyle {
  
  public init() { }
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 20, weight: .bold))
      .padding(.vertical, 20)
      .foregroundStyle(DesignSystemAsset.white.swiftUIColor)
      .background(DesignSystemAsset.black.swiftUIColor)
      .overlay {
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.white.opacity(0.24), lineWidth: 4)
      }
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

#Preview {
  Button {
    // no action
  } label: {
    Text("title")
      .frame(minWidth: 148)
  }
  .buttonStyle(CAKKButtonStyle_Large())
}
