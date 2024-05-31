//
//  Font+Pretendard.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public extension Font {
  enum PretendardWeight: String, CaseIterable {
    case black      = "Black"
    case extraBold  = "ExtraBold"
    case bold       = "Bold"
    case semiBold   = "SemiBold"
    case medium     = "Medium"
    case regular    = "Regular"
    case light      = "Light"
    case extraLight = "ExtraLight"
    case thin       = "Thin"
  }
  
  static func pretendard(size: CGFloat = 14,
                         weight: PretendardWeight = .regular) -> Font {
    switch weight {
    case .black:
      DesignSystemFontFamily.Pretendard.black.swiftUIFont(size: size)
    case .extraBold:
      DesignSystemFontFamily.Pretendard.extraBold.swiftUIFont(size: size)
    case .bold:
      DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: size)
    case .semiBold:
      DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: size)
    case .medium:
      DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: size)
    case .regular:
      DesignSystemFontFamily.Pretendard.regular.swiftUIFont(size: size)
    case .light:
      DesignSystemFontFamily.Pretendard.light.swiftUIFont(size: size)
    case .extraLight:
      DesignSystemFontFamily.Pretendard.extraLight.swiftUIFont(size: size)
    case .thin:
      DesignSystemFontFamily.Pretendard.thin.swiftUIFont(size: size)
    }
  }
}

#Preview {
  VStack {
    ForEach(Font.PretendardWeight.allCases, id: \.self) { weight in
      Text("Hello CAKK").font(.pretendard(size: 28, weight: weight))
    }
  }
}
