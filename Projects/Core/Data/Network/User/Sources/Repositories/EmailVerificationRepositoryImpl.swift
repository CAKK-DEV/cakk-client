//
//  EmailVerificationRepositoryImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import Moya
import CombineMoya

import Logger

public final class EmailVerificationRepositoryImpl: EmailVerificationRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<EmailVerificationAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<EmailVerificationAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func sendVerificationCode(email: String) -> AnyPublisher<Void, EmailVerificationError> {
    Loggers.networkUser.info("\(email) 로 인증번호 발송을 요청합니다.", category: .network)
    
    return provider.requestPublisher(.sendVerificationCode(email: email))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("일증번호가 발송되었습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(ConfirmVerificationCodeResponseDTO.self, from: response.data)
          switch Int(decodedResponse.returnCode)! {
          case 9000..<9999:
            Loggers.networkUser.info("서버 에러.", category: .network)
            throw EmailVerificationError.serverError
            
          default:
            Loggers.networkUser.info("인증번호 발송에 실패하였습니다: \(decodedResponse.returnCode) | \(decodedResponse.returnMessage)", category: .network)
            throw EmailVerificationError.failure
          }
        }
      }
      .mapError { error in
        if let error = error as? EmailVerificationError {
          return error
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return EmailVerificationError.failure
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func confirmVerificationCode(email: String, code: String) -> AnyPublisher<Void, EmailVerificationError> {
    Loggers.networkUser.info("\(email) 로 보낸 인증번호 \(code) 가 일치한지 확인합니다.", category: .network)
    
    return provider.requestPublisher(.confirmVerificationCode(email: email, code: code))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkUser.info("일증번호가 일치합니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(ConfirmVerificationCodeResponseDTO.self, from: response.data)
          switch Int(decodedResponse.returnCode)! {
          case 1204:
            Loggers.networkUser.info("인증번호가 일치하지 않습니다.", category: .network)
            throw EmailVerificationError.wrongVerificationCode
            
          case 9000..<9999:
            Loggers.networkUser.info("서버 에러.", category: .network)
            throw EmailVerificationError.serverError
            
          default:
            Loggers.networkUser.info("인증번호 일치 확인에 실패하였습니다: \(decodedResponse.returnCode) | \(decodedResponse.returnMessage)", category: .network)
            throw EmailVerificationError.failure
          }
        }
      }
      .mapError { error in
        if let error = error as? EmailVerificationError {
          return error
        } else {
          Loggers.networkUser.error("예측되지 못한 에러 \(error.localizedDescription)", category: .network)
          return EmailVerificationError.failure
        }
      }
      .eraseToAnyPublisher()
  }
}
