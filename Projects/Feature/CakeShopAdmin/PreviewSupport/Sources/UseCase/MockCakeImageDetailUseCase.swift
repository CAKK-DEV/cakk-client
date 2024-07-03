//
//  MockCakeImageDetailUseCase.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public struct MockCakeImageDetailUseCase: CakeImageDetailUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case failure
    case success
  }
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 1,
    scenario: Scenario = .success
  ) {
    self.delay = delay
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeImageId: Int) -> AnyPublisher<CakeImageDetail, CakeShopError> {
    switch scenario {
    case .failure:
      Fail(error: CakeShopError.failure)
        .eraseToAnyPublisher()
      
    case .success:
      Just(CakeImageDetail.mock())
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
    }
  }
}
