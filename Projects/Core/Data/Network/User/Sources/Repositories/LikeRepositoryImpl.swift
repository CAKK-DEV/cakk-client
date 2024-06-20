//
//  LikeRepository.swift
//  NetworkUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import Moya
import CombineMoya

import DomainUser

public final class LikeRepositoryImpl: LikeRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<LikeAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<LikeAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchLikedCakeShops(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[DomainUser.LikedCakeShop], DomainUser.LikeError> {
    provider.requestPublisher(.fetchLikedCakeShop(lastHeartId: lastHeartId, pageSize: pageSize, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikedCakeShopsResponseDTO.self, from: response.data)
          return decodedResponse.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikedCakeShopsResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }

  public func likeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    provider.requestPublisher(.likeCakeShop(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func unlikeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    provider.requestPublisher(.unlikeCakeShop(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeShopLikeState(shopId: Int, accessToken: String) -> AnyPublisher<Bool, DomainUser.LikeError> {
    provider.requestPublisher(.fetchLikedCakeShopState(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          return decodedResponse.data.isHeart
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchLikedCakeImages(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[DomainUser.LikedCakeImage], DomainUser.LikeError> {
    provider.requestPublisher(.fetchLikedCakeImage(lastHeartId: lastHeartId, pageSize: pageSize, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikedCakeImagesResponseDTO.self, from: response.data)
          return decodedResponse.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikedCakeImagesResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func likeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    provider.requestPublisher(.likeCakeImage(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func unlikeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    provider.requestPublisher(.unlikeCakeImage(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImageLikeState(imageId: Int, accessToken: String) -> AnyPublisher<Bool, DomainUser.LikeError> {
    provider.requestPublisher(.fetchLikedCakeImageState(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          return decodedResponse.data.isHeart
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          return networkError.toLikeError()
        } else {
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
}
