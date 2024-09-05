//
//  View+WhiteTextShadow.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public extension View {
  func whiteTextShadow() -> some View {
    self.shadow(color: .white.opacity(0.4), radius: 10, y: 2)
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    Text("Hello world")
      .font(.system(size: 40, weight: .heavy))
      .foregroundStyle(Color.white)
      .whiteTextShadow()
  }
}
