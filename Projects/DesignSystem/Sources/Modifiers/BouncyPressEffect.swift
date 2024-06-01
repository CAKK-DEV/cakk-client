//
//  BouncyPressEffect.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public struct BouncyPressEffect: ViewModifier {
  
  // MARK: - Properties
  
  @State private var isPressed = false
  
  
  // MARK: - Initializers
  
  public init(isPressed: Bool = false) {
    self.isPressed = isPressed
  }
  
  
  // MARK: - Views
  
  public func body(content: Content) -> some View {
    content
      .disableDefaultPressEffect()
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged({ _ in
            isPressed = true
          })
          .onEnded({ _ in
            isPressed = false
          })
      )
      .scaleEffect(isPressed ? 0.95 : 1.0)
      .animation(.bouncy(duration: 0.3), value: isPressed)
  }
}


// MARK: - Preview

#Preview {
  Button {
    // no action
  } label: {
    Text("title")
      .padding(12)
      .foregroundStyle(.white)
      .background(Color.blue)
  }
  .modifier(BouncyPressEffect())
}
