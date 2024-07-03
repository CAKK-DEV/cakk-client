//
//  MockSearchCakeShopUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public struct MockSearchCakeShopUseCase: SearchCakeShopUseCase {
  
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
  
  public func execute(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeShopId: Int?) -> AnyPublisher<[CakeShop], any Error> {
    switch scenario {
    case .success:
      if let lastCakeShopId {
        switch lastCakeShopId {
        case 6:
          return Just(CakeShop.mockCakeShops2)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        case 12:
          return Just(CakeShop.mockCakeShops3)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        default:
          return Just(CakeShop.mockCakeShops4)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      } else {
        return Just(CakeShop.mockCakeShops1)
          .delay(for: .seconds(delay), scheduler: RunLoop.main)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      
    case .failure:
      return Fail(error: NSError(domain: "preview", code: -1))
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  }
}
