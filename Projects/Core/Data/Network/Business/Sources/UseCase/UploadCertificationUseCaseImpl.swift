//
//  UploadCertificationUseCaseImpl.swift
//  NetworkBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit

import Combine
import Moya

import DomainBusiness

import UserSession

public final class UploadCertificationUseCaseImpl: UploadCertificationUseCase {
  
  // MARK: - Properties
  
  private let repository: BusinessRepository
  
  
  // MARK: - Initializers
  
  public init(repository: BusinessRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, UploadCertificationError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.uploadCertification(shopId: shopId,
                                     businessRegistrationImage: businessRegistrationImage,
                                     idCardImage: idCardImage,
                                     contact: contact,
                                     message: message,
                                     accessToken: accessToken)
    } else {
      Fail(error: UploadCertificationError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
