//
//  StepRouter.swift
//  CAKK
//
//  Created by 이승기 on 5/3/24.
//

import SwiftUI

public class StepRouter: ObservableObject {
  
  // MARK: - Properties
  
  @Published public var steps: [AnyView]
  @Published public var currentStep: Int = 0
  
  var parentCoordinator: StepRouter?
  
  var onFinish: (() -> Void)?
  
  
  // MARK: - Initializers
  
  public init(steps: [AnyView], parentCoordinator: StepRouter? = nil, onFinish: (() -> Void)? = nil) {
    self.steps = steps
    self.parentCoordinator = parentCoordinator
    self.onFinish = onFinish
  }
  
  
  // MARK: - Public Methods
  
  public func popStep() {
    // 더이상 이전 단계가 없다면 현 coordinator의 step을 부모의 step으로 치환
    if currentStep == 0 {
      if let parentCoordinator = parentCoordinator {
        steps = parentCoordinator.steps
        // 상위에서 하위 coordinator 로 넘어올때 step이 이미 한 단계 진행된 상태로 넘어가기 때문에 복구 필요
        currentStep = parentCoordinator.currentStep - 1
      }
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
  
  public func withParent(coordinator: StepRouter) -> Self {
    self.parentCoordinator = coordinator
    return self
  }
}
