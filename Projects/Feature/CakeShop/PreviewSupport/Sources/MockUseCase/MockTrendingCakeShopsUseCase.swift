//
//  MockTrendingCakeShopsUseCase.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public struct MockTrendingCakeShopsUseCase: TrendingCakeShopsUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  private let scenario: Scenario
  public enum Scenario {
    case success
    case failure
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
  
  public func execute() -> AnyPublisher<[TrendingCakeShop], any Error> {
    switch scenario {
    case .success:
      Just(TrendingCakeShop.mockCakeShops)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
      
    case .failure:
      Fail(error: NSError(domain: "preview", code: -1))
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  }
}
