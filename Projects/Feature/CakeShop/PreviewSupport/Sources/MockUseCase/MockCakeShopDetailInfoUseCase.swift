//
//  MockCakeShopAdditionalInfoUseCase.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public struct MockCakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase {
  
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
  
  public func execute(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, any Error> {
    switch scenario {
    case .failure:
      return Fail(error: NSError(domain: "preview", code: -1))
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
      
    case .success:
      return Just(CakeShopAdditionalInfo.mock)
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }
}
