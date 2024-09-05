//
//  AnimatedGradientBackground.swift
//  CAKK
//
//  Created by 이승기 on 5/2/24.
//

import SwiftUI

public struct AnimatedGradientBackground: View {
  
  // MARK: - Initializers
  
  public init(
    backgroundColor: Color,
    gradientColors: [Color]
  ) {
    self.backgroundColor = backgroundColor
    self.gradientColors = gradientColors
    
    self.animator = CircleAnimator(colors: gradientColors)
  }
  
  
  // MARK: - Properties
  
  private let backgroundColor: Color
  private let gradientColors: [Color]
  
  private enum AnimationProperties {
    static let animationSpeed: Double = 3
    static let timerDuration: TimeInterval = 2
    static let blueRadius: CGFloat = 80
  }
  
  private struct MovingCircle: Shape {
    var originOffset: CGPoint
    var animatableData: CGPoint.AnimatableData {
      get {
        originOffset.animatableData
      }
      set {
        originOffset.animatableData = newValue
      }
    }
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      let adjustedX = rect.width * originOffset.x * 1.2
      let adjustedY = rect.height * originOffset.y * 1.2
      let smallestDimension = min(rect.width, rect.height)
      
      path.addArc(center: CGPoint(x: adjustedX, y: adjustedY),
                  radius: smallestDimension / 2,
                  startAngle: .zero,
                  endAngle: .degrees(360),
                  clockwise: true)
      return path
    }
  }
  
  @State private var timer = Timer.publish(every: AnimationProperties.timerDuration,
                                           on: .main,
                                           in: .common).autoconnect()
  
  @ObservedObject private var animator: CircleAnimator
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      ForEach(animator.circles) { circle in
        MovingCircle(originOffset: circle.position)
          .foregroundColor(circle.color)
      }
    }
    .blur(radius: AnimationProperties.blueRadius)
    .background(backgroundColor)
    .onDisappear {
      timer.upstream.connect().cancel()
    }
    .onAppear {
      animateCircles()
      timer = Timer.publish(every: AnimationProperties.timerDuration,
                            on: .main,
                            in: .common).autoconnect()
    }
    .onReceive(timer) { _ in
      animateCircles()
    }
  }
  
  // MARK: - Methods
  
  private func animateCircles() {
    withAnimation(.easeInOut(duration: AnimationProperties.animationSpeed)) {
      animator.animate()
    }
  }
}


// MARK: - CircleAnimator

private class CircleAnimator: ObservableObject {
  
  class Circle: Identifiable {
    let id = UUID().uuidString
    var position: CGPoint
    var color: Color
    
    init(position: CGPoint, color: Color) {
      self.position = position
      self.color = color
    }
  }
  
  @Published private(set) var circles: [Circle] = []
  
  init(colors: [Color]) {
    self.circles = colors.map { Circle(position: CircleAnimator.generateRandomPosition(), color: $0) }
  }
  
  func animate() {
    objectWillChange.send()
    
    for circle in circles {
      circle.position = CircleAnimator.generateRandomPosition()
    }
  }
  
  static func generateRandomPosition() -> CGPoint {
    .init(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
  }
}



// MARK: - Preview

#Preview {
  AnimatedGradientBackground(backgroundColor: Color(hex: "FEB0CD"),
                             gradientColors: [
                              Color(hex: "FE85A5"),
                              Color(hex: "FE85A5"),
                              Color(hex: "FED6C3")
                             ])
}
