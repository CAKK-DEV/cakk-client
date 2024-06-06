//
//  some.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public struct MockCakeImagesByCategoryUseCase: CakeImagesByCategoryUseCase {
  
  // MARK: - Preview
  
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
  
  public func execute(category: DomainCakeShop.CakeCategory, count: Int, lastCakeId: Int?) -> AnyPublisher<[DomainCakeShop.CakeImage], any Error> {
    switch scenario {
    case .failure:
      return Fail(error: NSError(domain: "preview", code: -1))
        .eraseToAnyPublisher()
      
    case .success:
      if let lastCakeId {
        switch lastCakeId {
        case 10:
          return Just(CakeImage.mockCakeImages2)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        case 20:
          return Just(CakeImage.mockCakeImages3)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        default:
          return Just(CakeImage.mockCakeImages4)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      } else {
        return Just(CakeImage.mockCakeImages1)
          .delay(for: .seconds(delay), scheduler: RunLoop.main)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
    }
  }
}
