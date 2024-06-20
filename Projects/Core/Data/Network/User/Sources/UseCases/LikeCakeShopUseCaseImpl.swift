//
//  LikeUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class LikeCakeShopUseCaseImpl: LikeCakeShopUseCase {
  
  // MARK: - Properties
  
  private let repository: LikeRepository
  
  
  // MARK: - Initializers
  
  public init(repository: LikeRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func likeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.likeCakeShop(shopId: shopId, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func unlikeCakeShop(shopId: Int) -> AnyPublisher<Void, LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.unlikeCakeShop(shopId: shopId, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchLikedCakeShops(lastShopId: Int?, pageSize: Int) -> AnyPublisher<[DomainUser.LikedCakeShop], DomainUser.LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.fetchLikedCakeShops(lastHeartId: lastShopId, pageSize: pageSize, accessToken: accessToken)
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
  
  public func fetchCakeShopLikedState(shopId: Int) -> AnyPublisher<Bool, DomainUser.LikeError> {
    if let accessToken = UserSession.shared.accessToken {
      return repository.fetchCakeShopLikeState(shopId: shopId, accessToken: accessToken)
    } else {
      return Fail(error: LikeError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
