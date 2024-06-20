//
//  MockLikeUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockLikeCakeShopUseCase: LikeCakeShopUseCase {
  
  // MARK: - Properties
  
  private let scenario: Scenario
  public enum Scenario {
    case success
    case sessionExpired
  }
  
  
  // MARK: - Initializers
  
  public init(scenario: Scenario = .success) {
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func likeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError> {
    switch scenario {
    case .success:
      Just(Void())
        .setFailureType(to: LikeError.self)
        .eraseToAnyPublisher()
      
    case .sessionExpired:
      Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func unlikeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError> {
    Just(Void())
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
  
  public func fetchLikedCakeShops(lastShopId: Int?, pageSize: Int) -> AnyPublisher<[DomainUser.LikedCakeShop], DomainUser.LikeError> {
    Just([])
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeShopLikedState(shopId: Int) -> AnyPublisher<Bool, DomainUser.LikeError> {
    Just(Bool.random())
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
}
