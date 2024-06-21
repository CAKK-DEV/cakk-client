//
//  MockSearchCakeImagesUseCase.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainSearch

public struct MockSearchCakeImagesUseCase: SearchCakeImagesUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  
  public enum Scenario {
    case success
    case noImages
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
  
  public func execute(keyword: String?,
                      latitude: Double = 0,
                      longitude: Double = 0,
                      pageSize: Int = 0,
                      lastCakeId: Int? = nil) -> AnyPublisher<[CakeImage], any Error> {
    switch scenario {
    case .success:
      if let lastCakeId {
        switch lastCakeId {
        case 10:
          return Just(CakeImage.mockCakeImages2)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        case 20:
          return Just(CakeImage.mockCakeImages3)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        default:
          return Just(CakeImage.mockCakeImages4)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      } else {
        return Just(CakeImage.mockCakeImages1)
          .delay(for: .seconds(delay), scheduler: RunLoop.main)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      
    case .noImages:
      return Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
      
    case .failure:
      return Fail(error: NSError(domain: "preview", code: -1))
        .eraseToAnyPublisher()
    }
  }
}
