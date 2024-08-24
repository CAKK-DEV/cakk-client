//
//  Steprouter.swift
//  CommonUtil
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public class StepRouter: ObservableObject {
  
  // MARK: - Properties
  
  @Published public var steps: [AnyView]
  @Published public var currentStep: Int = 0
  
  var onFinish: (() -> Void)?
  
  
  // MARK: - Initializers
  
  public init(
    steps: [AnyView],
    onFinish: (() -> Void)? = nil)
  {
    self.steps = steps
    self.onFinish = onFinish
  }
  
  
  // MARK: - Public Methods
  
  public func popStep() {
    /// 더이상 이전 단계가 없다면 onFinish 호출하여 step 종료
    if currentStep == 0 {
      onFinish?()
      return
    }
    
    if currentStep > 0 {
      currentStep -= 1
    }
  }
  
  public func popToRoot() {
    currentStep = 0
  }
  
  public func pushStep() {
    if currentStep + 1 < steps.count {
      currentStep += 1
    } else {
      onFinish?()
    }
  }
  
  public func finish() {
    onFinish?()
  }
}
