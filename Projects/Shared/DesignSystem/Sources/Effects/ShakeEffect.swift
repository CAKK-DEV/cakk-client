//
//  ShakeEffect.swift
//  DesignSystem
//
//  Created by 이승기 on 8/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct Shake: GeometryEffect {
  private var amount: CGFloat = 4
  private var shakesPerUnit = 3
  public var animatableData: CGFloat
  
  public init(animatableData: CGFloat) {
    self.animatableData = animatableData
  }

  public func effectValue(size: CGSize) -> ProjectionTransform {
    ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
  }
}
