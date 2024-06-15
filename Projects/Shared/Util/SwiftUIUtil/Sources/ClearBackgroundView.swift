//
//  ClearBackgroundView.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import UIKit

/**
 `ClearBackgroundView`는 뷰의 뒷 배경을 투명하게 만들기 위해 사용됩니다. `UIViewRepresentable`을 채택하여 SwiftUI와 UIKit 간의 상호 운용성을 제공합니다.

 사용 예제:
 ```swift
 .fullScreenCover(isPresented: $isPresented, content: {
     MyFullScreenView()
         .background(ClearBackgroundView())
 })
 이 예제에서 ClearBackgroundView는 MyFullScreenView의 배경을 투명하게 만듭니다.
 */
public struct ClearBackgroundView: UIViewRepresentable {
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - LifeCycle
  
  public func makeUIView(context: Context) -> UIView {
    return InnerView()
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) { }
  
  private class InnerView: UIView {
    override func didMoveToWindow() {
      super.didMoveToWindow()
      superview?.superview?.backgroundColor = .clear
    }
  }
}
