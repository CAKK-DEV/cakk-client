//
//  ScrollViewOffset.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct ScrollViewOffset<Content: View>: View {
  let onOffsetChange: (CGFloat) -> Void
  let content: () -> Content
  
  public init(
    onOffsetChange: @escaping (CGFloat) -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.onOffsetChange = onOffsetChange
    self.content = content
  }
  
  public var body: some View {
    ScrollView {
      offsetReader
      content()
        .padding(.top, -8)
    }
    .coordinateSpace(name: "frameLayer")
    .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
  }
  
  var offsetReader: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: OffsetPreferenceKey.self,
          value: proxy.frame(in: .named("frameLayer")).minY
        )
    }
    .frame(height: 0)
  }
}

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
