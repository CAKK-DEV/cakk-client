//
//  MockCakeShopOwnerVerificationUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusinessOwner

public struct MockCakeShopOwnerVerificationUseCase: CakeShopOwnerVerificationUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case success
    case failure
    case serverError
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
  
  public func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, BusinessOwnerError> {
    switch scenario {
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: BusinessOwnerError.self)
        .eraseToAnyPublisher()
      
    case .failure:
      Fail(error: BusinessOwnerError.failure)
        .eraseToAnyPublisher()
      
    case .serverError:
      Fail(error: BusinessOwnerError.serverError)
        .eraseToAnyPublisher()
    }
  }
}

