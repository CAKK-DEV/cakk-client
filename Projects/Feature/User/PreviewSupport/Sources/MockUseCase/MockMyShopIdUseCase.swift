//
//  MockMyShopIdUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockMyShopIdUseCase: MyShopIdUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case myShop
    case notMyShop
  }
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 0,
    scenario: Scenario = .notMyShop
  ) {
    self.delay = delay
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func execute() -> AnyPublisher<Int?, UserProfileError> {
    switch scenario {
    case .myShop:
      Just(0)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
      
    case .notMyShop:
      Just(-1)
        .setFailureType(to: UserProfileError.self)
        .eraseToAnyPublisher()
    }
  }
}
