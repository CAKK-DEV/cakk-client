//
//  MockCakeShopOwnedStateUseCase.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public struct MockCakeShopOwnedStateUseCase: CakeShopOwnedStateUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case owned
    case notOwned
  }
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 1.0,
    scenario: Scenario = .owned
  ) {
    self.delay = delay
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int) -> AnyPublisher<Bool, CakeShopError> {
    switch scenario {
    case .owned:
      Just(true)
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
      
    case .notOwned:
      Just(false)
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
    }
  }
}
