//
//  MockUploadCakeImageUseCase.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine
import DomainCakeShop

public struct MockUploadCakeImageUseCase: UploadCakeImageUseCase {
  
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
  
  public func execute(cakeShopId: Int, image: UIImage, categories: [DomainCakeShop.CakeCategory], tags: [String]) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
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
