//
//  MockCakeShopQuickInfoUseCase.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public struct MockCakeShopQuickInfoUseCase: CakeShopQuickInfoUseCase {
  
  private let delay: TimeInterval
  
  public init(delay: TimeInterval = 1.0) {
    self.delay = delay
  }
  
  public func execute(shopId: Int) -> AnyPublisher<DomainCakeShop.CakeShopQuickInfo, any Error> {
    Just(CakeShopQuickInfo.mock)
      .delay(for: .seconds(delay), scheduler: RunLoop.main)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
