//
//  BusinessOwnerRepositoryImpl.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import Moya
import CombineMoya

import DomainBusinessOwner

import Logger

public class BusinessOwnerRepositoryImpl: BusinessOwnerRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<BusinessOwnerAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<BusinessOwnerAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImageUrl: String, idCardImageUrl: String, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, BusinessOwnerError> {
    Loggers.networkBusinessOwner.info("사장님 인증 요청을 시작합니다.", category: .network)
    
    return provider.requestPublisher(.requestCakeShopOwnerVerification(shopId: shopId,
                                                                businessRegistrationImageUrl: businessRegistrationImageUrl,
                                                                idCardImageUrl: idCardImageUrl,
                                                                contact: contact,
                                                                message: message,
                                                                accessToken: accessToken)
    )
    .tryMap { response in
      switch response.statusCode {
      case 200..<300:
        Loggers.networkBusinessOwner.info("사장님 인증 요청에 성공하였습니다.", category: .network)
        return Void()
        
      default:
        let decodedResponse = try JSONDecoder().decode(OwnerVerificationResponseDTO.self, from: response.data)
        throw BusinessOwnerNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
      }
    }
    .mapError { error in
      if let networkError = error as? BusinessOwnerNetworkError {
        Loggers.networkBusinessOwner.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
        return networkError.toBusinessOwnerError()
      } else {
        Loggers.networkBusinessOwner.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return BusinessOwnerNetworkError.error(for: error).toBusinessOwnerError()
      }
    }
    .eraseToAnyPublisher()
  }
}
