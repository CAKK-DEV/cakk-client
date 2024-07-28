//
//  MockSearchLocatedCakeShopUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public struct MockSearchLocatedCakeShopUseCase: SearchLocatedCakeShopUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  
  
  // MARK: - Initializers
  
  public init(delay: TimeInterval = 1) {
    self.delay = delay
  }
  
  
  // MARK: - Public Methods
  
  public func execute(distance: Int, longitude: Double, latitude: Double) -> AnyPublisher<[LocatedCakeShop], any Error> {
    Just(LocatedCakeShop.mockCakeShops)
      .delay(for: .seconds(delay), scheduler: RunLoop.main)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
