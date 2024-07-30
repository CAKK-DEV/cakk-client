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

import Logger

public final class LikeRepositoryImpl: LikeRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<LikeAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<LikeAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetchLikedCakeShops(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[DomainUser.LikedCakeShop], DomainUser.LikeError> {
    if lastHeartId != nil {
      Loggers.networkUser.info("좋아요한 케이크샵들을 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkUser.info("좋아요한 케이크샵들을 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchLikedCakeShop(lastHeartId: lastHeartId, pageSize: pageSize, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikedCakeShopsResponseDTO.self, from: response.data)
          Loggers.networkUser.info("좋아요한 케이크샵들을 불러오기에 성공하였습니다.\n불러온 케이크샵 갯수: \(decodedResponse.data.size)", category: .network)
          return decodedResponse.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikedCakeShopsResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }

  public func likeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.likeCakeShop(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요 요청에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func unlikeCakeShop(shopId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요 취소를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.unlikeCakeShop(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요 취소 요청에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeShopLikeState(shopId: Int, accessToken: String) -> AnyPublisher<Bool, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요 상태를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.fetchLikedCakeShopState(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          Loggers.networkUser.info("아이디 \(shopId) 의 케이크샵 좋아요 상태를 불러오는데 성공하였습니다.\n좋아요한 상태는 \(decodedResponse.data.isHeart).", category: .network)
          return decodedResponse.data.isHeart
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchLikedCakeImages(lastHeartId: Int?, pageSize: Int, accessToken: String) -> AnyPublisher<[DomainUser.LikedCakeImage], DomainUser.LikeError> {
    if lastHeartId != nil {
      Loggers.networkUser.info("좋아요한 케이크이미지를 더 불러옵니다.", category: .network)
    } else {
      Loggers.networkUser.info("좋아요한 케이크이미지를 불러옵니다.", category: .network)
    }
    
    return provider.requestPublisher(.fetchLikedCakeImage(lastHeartId: lastHeartId, pageSize: pageSize, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikedCakeImagesResponseDTO.self, from: response.data)
          Loggers.networkUser.info("좋아요한 케이크이미지를 불러오는데 성공하였습니다.\n불러온 이미지의 갯수: \(decodedResponse.data.size).", category: .network)
          return decodedResponse.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikedCakeImagesResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func likeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.likeCakeImage(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요 요청에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func unlikeCakeImage(imageId: Int, accessToken: String) -> AnyPublisher<Void, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요 취소를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.unlikeCakeImage(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요 취소 요청에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImageLikeState(imageId: Int, accessToken: String) -> AnyPublisher<Bool, DomainUser.LikeError> {
    Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요 상태를 요청합니다.", category: .network)
    
    return provider.requestPublisher(.fetchLikedCakeImageState(imageId: imageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          Loggers.networkUser.info("아이디 \(imageId) 이미지 좋아요 상태 요청에 성공하였습니다.\n좋아요 상태: \(decodedResponse.data.isHeart)", category: .network)
          return decodedResponse.data.isHeart
          
        default:
          let decodedResponse = try JSONDecoder().decode(LikeStateResponseDTO.self, from: response.data)
          throw CAKKUserNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CAKKUserNetworkError {
          Loggers.networkUser.error("네트워크 에러 \(networkError.localizedDescription)", category: .network)
          return networkError.toLikeError()
        } else {
          Loggers.networkSearch.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CAKKUserNetworkError.error(for: error).toLikeError()
        }
      }
      .eraseToAnyPublisher()
  }
}
