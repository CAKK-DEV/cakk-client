//
//  MockEditWorkingDayUseCase.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public struct MockEditWorkingDayUseCase: EditWorkingDayUseCase {
  
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
  
  public func execute(shopId: Int, workingDaysWithTime: [DomainCakeShop.WorkingDayWithTime]) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    switch scenario {
    case .failure:
      Fail(error: CakeShopError.failure)
        .eraseToAnyPublisher()
      
    case .success:
      Just(Void())
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
    }
  }
}
