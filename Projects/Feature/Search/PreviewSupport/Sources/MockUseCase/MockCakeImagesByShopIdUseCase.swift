//
//  MockCakeImagesByShopIdUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 7/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainSearch

public struct MockCakeImagesByShopIdUseCase: CakeImagesByShopIdUseCase {
  
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
  
  public func execute(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    switch scenario {
    case .failure:
      return Fail(error: NSError(domain: "preview", code: -1))
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
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
