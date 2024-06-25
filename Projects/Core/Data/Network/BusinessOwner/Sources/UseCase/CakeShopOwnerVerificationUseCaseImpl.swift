//
//  CakeShopOwnerVerificationUseCaseImpl.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusinessOwner

import UserSession

public final class CakeShopOwnerVerificationUseCaseImpl: CakeShopOwnerVerificationUseCase {
  
  // MARK: - Properties
  
  private let repository: BusinessOwnerRepository
  
  
  // MARK: - Initializers
  
  public init(repository: BusinessOwnerRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, BusinessOwnerError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.requestCakeShopOwnerVerification(shopId: shopId,
                                          businessRegistrationImage: businessRegistrationImage,
                                          idCardImage: idCardImage,
                                          contact: contact,
                                          message: message,
                                          accessToken: accessToken)
    } else {
      Fail(error: BusinessOwnerError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
