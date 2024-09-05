//
//  LottieViewRepresentable.swift
//  DesignSystem
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import SwiftUI
import Lottie

import UIKit

public struct LottieViewRepresentable: UIViewRepresentable {
  
  // MARK: - Properties
  
  private let lottieFile: LottieFile
  private let loopMode: LottieLoopMode
  private let contentMode: UIView.ContentMode
  
  public enum LottieFile: String {
    /// rawValue를 lottie animation의 json 이름으로 설정해주세요.
    case confetti = "confetti"
    case cakeRunning = "cake_running"
    case heartFlyAway = "heart_fly_away"
  }
  
  
  // MARK: - Initializers
  
  public init(
    lottieFile: LottieFile,
    loopMode : LottieLoopMode = .loop,
    contentMode: UIView.ContentMode = .scaleAspectFit
  ){
    self.lottieFile = lottieFile
    self.loopMode = loopMode
    self.contentMode = contentMode
  }
  
  
  // MARK: - LifeCycle
  
  public func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    
    let animationView = LottieAnimationView(name: lottieFile.rawValue, bundle: DesignSystemResources.bundle)
    animationView.contentMode = contentMode
    animationView.loopMode = loopMode
    animationView.play()
    animationView.backgroundBehavior = .pauseAndRestore
    
    
    animationView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(animationView)
    NSLayoutConstraint.activate([
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])
    
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) { }
}
