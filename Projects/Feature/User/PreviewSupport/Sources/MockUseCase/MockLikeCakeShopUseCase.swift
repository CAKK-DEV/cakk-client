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
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case success
    case sessionExpired
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
    switch scenario {
    case .success:
      if let lastShopId {
        switch lastShopId {
        case 6:
          return Just(LikedCakeShop.mockLikedCakeShops2)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        case 12:
          return Just(LikedCakeShop.mockLikedCakeShops3)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        default:
          return Just(LikedCakeShop.mockLikedCakeShops4)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        }
      } else {
        return Just(LikedCakeShop.mockLikedCakeShops1)
          .delay(for: .seconds(delay), scheduler: RunLoop.main)
          .setFailureType(to: LikeError.self)
          .eraseToAnyPublisher()
      }
      
    case .sessionExpired:
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchCakeShopLikedState(shopId: Int) -> AnyPublisher<Bool, DomainUser.LikeError> {
    Just(Bool.random())
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
}
