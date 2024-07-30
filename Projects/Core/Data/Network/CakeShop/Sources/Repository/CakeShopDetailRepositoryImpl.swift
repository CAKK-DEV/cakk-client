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

import Logger

final public class CakeShopDetailRepositoryImpl: CakeShopDetailRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<CakeShopAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<CakeShopAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func fetch(shopId: Int) -> AnyPublisher<DomainCakeShop.CakeShopDetail, DomainCakeShop.CakeShopDetailError> {
    Loggers.networkCakeShop.info("케이크샵 상세 정보 불러오기를 시작합니다.", category: .network)
    
    return provider.requestPublisher(.fetchCakeShopDetail(shopId: shopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopDetailResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkCakeShop.info("케이크샵 상세 정보 불러오기에 성공하였습니다.\n\(data)", category: .network)
          return data.toDomain()
          
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toCakeShopDetailError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toCakeShopDetailError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchAdditionalInfo(shopId: Int) -> AnyPublisher<CakeShopAdditionalInfo, Error> {
    Loggers.networkCakeShop.info("케이크샵 추가정보 불러오기를 시작합니다", category: .network)
    
    return provider.requestPublisher(.fetchAdditionalInfo(shopId: shopId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopAdditionalInfoDTO.self.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkCakeShop.info("케이크샵 추가정보 불러오기에 성공하였습니다.\n\(data)", category: .network)
          return data.toDomain()
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toCakeShopDetailError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toCakeShopDetailError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func isOwned(shopId: Int, accessToken: String) -> AnyPublisher<Bool, CakeShopError> {
    Loggers.networkCakeShop.info("케이크샵이 사장님에게 점유되었는지 여부를 확인합니다.", category: .network)
    
    return provider.requestPublisher(.isOwned(shopId: shopId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeShopOwnedStateResponseDTO.self.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          Loggers.networkCakeShop.info("케이크샵의 점유 상태는 \(data.isOwned) 입니다.", category: .network)
          return data.isOwned
          
        default:
          throw CakeShopNetworkError.unexpected(NSError(domain: "CakeShopAPI", code: response.statusCode))
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
}
