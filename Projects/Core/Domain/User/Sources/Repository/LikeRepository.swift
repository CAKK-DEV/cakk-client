//
//  LikeRepository.swift
//  DomainUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol LikeRepository {
  
  // MARK: - CakeShop

  func fetchLikedCakeShops(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[LikedCakeShop], LikeError>
  func likeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, LikeError>
  func unlikeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, LikeError>
  func fetchCakeShopLikeState(shopId: Int, accessToken: String) -> AnyPublisher<Bool, LikeError>
  
  
  // MARK: - CakeImage

  func fetchLikedCakeImages(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[LikedCakeImage], LikeError>
  func likeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, LikeError>
  func unlikeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, LikeError>
  func fetchCakeImageLikeState(imageId: Int, accessToken: String) -> AnyPublisher<Bool, LikeError>
}
