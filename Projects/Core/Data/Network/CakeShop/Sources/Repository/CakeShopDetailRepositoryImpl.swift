//
//  CakeShopDetailRepositoryImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import Moya
import CombineMoya

import DomainCakeShop

final public class CakeShopDetailRepositoryImpl: CakeShopDetailRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<CakeShopAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<CakeShopAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetch(shopId: Int) -> AnyPublisher<DomainCakeShop.CakeShopDetail, DomainCakeShop.CakeShopDetailError> {
    provider.requestPublisher(.fetchCakeShopDetail(shopId: shopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopDetailResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          return data.toDomain()
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toCakeShopDetailError()
        } else {
          return CakeShopNetworkError.error(for: error).toCakeShopDetailError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchAdditionalInfo(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, Error> {
    provider.requestPublisher(.fetchAdditionalInfo(shopId: shopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopAdditionalInfoDTO.self.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          return data.toDomain()
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toCakeShopDetailError()
        } else {
          return CakeShopNetworkError.error(for: error).toCakeShopDetailError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchCakeImages(shopId: Int, count: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error> {
    provider.requestPublisher(.fetchCakeImagesByShopId(shopId, count: count, lastCakeId: lastCakeId))
      .map { $0.data }
      .decode(type: CakeImagesResponseDTO.self, decoder: JSONDecoder())
      .tryMap { response in
        response.toDomain()
      }
      .eraseToAnyPublisher()
  }
  
  public func isOwned(shopId: Int, accessToken: String) -> AnyPublisher<Bool, CakeShopError> {
    provider.requestPublisher(.isOwned(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopOwnedStateResponseDTO.self.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          return data.isOwned
          
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
}
