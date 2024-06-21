//
//  MockLikeCakeImageUseCase.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public struct MockLikeCakeImageUseCase: LikeCakeImageUseCase {
  
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
  
  public func likeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError> {
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
  
  public func unlikeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError> {
    Just(Void())
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
  
  public func fetchLikedCakeImages(lastImageId: Int?, pageSize: Int) -> AnyPublisher<[DomainUser.LikedCakeImage], DomainUser.LikeError> {
    
    switch scenario {
    case .success:
      if let lastImageId {
        switch lastImageId {
        case 10:
          return Just(LikedCakeImage.mockLikedCakeImages2)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        case 20:
          return Just(LikedCakeImage.mockLikedCakeImages3)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        default:
          return Just(LikedCakeImage.mockLikedCakeImages4)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: LikeError.self)
            .eraseToAnyPublisher()
        }
      } else {
        return Just(LikedCakeImage.mockLikedCakeImages1)
          .delay(for: .seconds(delay), scheduler: RunLoop.main)
          .setFailureType(to: LikeError.self)
          .eraseToAnyPublisher()
      }
    
    case .sessionExpired:
      return Fail(error: LikeError.failure)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchCakeImageLikedState(imageId: Int) -> AnyPublisher<Bool, DomainUser.LikeError> {
    Just(Bool.random())
      .setFailureType(to: LikeError.self)
      .eraseToAnyPublisher()
  }
}
