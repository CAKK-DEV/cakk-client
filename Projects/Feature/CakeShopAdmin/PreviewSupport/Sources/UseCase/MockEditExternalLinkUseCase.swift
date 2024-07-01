//
//  MockEditExternalLinkUseCase.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public final class MockEditExternalLinkUseCase: EditExternalLinkUseCase {
  
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
  
  public func execute(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?) -> AnyPublisher<Void, CakeShopError> {
    switch scenario {
    case .success:
      Just(Void())
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
      
    case .failure:
      Fail(error: CakeShopError.failure)
        .eraseToAnyPublisher()
    }
  }
}
