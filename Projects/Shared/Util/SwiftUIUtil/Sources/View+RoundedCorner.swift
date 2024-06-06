//
//  View+RoundedCorner.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public extension View {
  func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners) )
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}



// MARK: - Preview

#Preview {
  VStack {
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.topLeft])
    
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.topRight])
    
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.bottomLeft])
    
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.bottomRight])
    
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.topLeft, .topRight])
    
    Rectangle()
      .fill(.black)
      .frame(width: 100, height: 60)
      .roundedCorner(15, corners: [.bottomLeft, .bottomRight])
  }
}
