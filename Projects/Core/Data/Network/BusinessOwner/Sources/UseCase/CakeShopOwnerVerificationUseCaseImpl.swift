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
import NetworkImage

import UserSession

public final class CakeShopOwnerVerificationUseCaseImpl: CakeShopOwnerVerificationUseCase {
  
  // MARK: - Properties
  
  private let businessOwnerRepository: BusinessOwnerRepository
  private let imageUploadRepository: ImageUploadRepository
  
  
  // MARK: - Initializers
  
  public init(
    businessOwnerRepository: BusinessOwnerRepository,
    imageUploadRepository: ImageUploadRepository
  ) {
    self.businessOwnerRepository = businessOwnerRepository
    self.imageUploadRepository = imageUploadRepository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, BusinessOwnerError> {
    if let accessToken = UserSession.shared.accessToken {
      
      imageUploadRepository.uploadImage(image: businessRegistrationImage)
        .combineLatest(imageUploadRepository.uploadImage(image: idCardImage))
        .mapError { error -> BusinessOwnerError in
          return .imageUploadFailure
        }
        .flatMap { [businessOwnerRepository] businessRegistrationImageUrl, idCardImageUrl in
          businessOwnerRepository.requestCakeShopOwnerVerification(shopId: shopId,
                                                                   businessRegistrationImageUrl: businessRegistrationImageUrl,
                                                                   idCardImageUrl: idCardImageUrl,
                                                                   contact: contact,
                                                                   message: message,
                                                                   accessToken: accessToken)
        }
        .eraseToAnyPublisher()
    } else {
      Fail(error: BusinessOwnerError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
