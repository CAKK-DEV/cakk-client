//
//  LikeCakeImageUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class LikeCakeImageUseCaseImpl: LikeCakeImageUseCase {
  
  // MARK: - Properties
  
  private let repository: LikeRepository
  
  
  // MARK: - Initializers
  
  public init(repository: LikeRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func likeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.likeCakeImage(imageId: imageId, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func unlikeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.unlikeCakeImage(imageId: imageId, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchLikedCakeImages(lastImageId: Int?, pageSize: Int) -> AnyPublisher<[DomainUser.LikedCakeImage], DomainUser.LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.fetchLikedCakeImages(lastHeartId: lastImageId, pageSize: pageSize, accessToken: accessToken)
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchCakeImageLikedState(imageId: Int) -> AnyPublisher<Bool, DomainUser.LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.fetchCakeImageLikeState(imageId: imageId, accessToken: accessToken)
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
