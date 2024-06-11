//
//  MockCakeShopDetailUseCase.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public struct MockCakeShopDetailUseCase: CakeShopDetailUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  private let scenario: Scenario
  public enum Scenario {
    case failure
    case noExists
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
  
  public func execute(shopId: Int) -> AnyPublisher<CakeShopDetail, CakeShopDetailError> {
    switch scenario {
    case .failure:
      Fail(error: CakeShopDetailError.failure)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
      
    case .noExists:
      Fail(error: CakeShopDetailError.noExists)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
      
    case .success:
      Just(CakeShopDetail.mock)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: CakeShopDetailError.self)
        .eraseToAnyPublisher()
    }
  }
}
