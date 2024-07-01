//
//  UploadCakeImageUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainCakeShop
import UserSession

public final class UploadCakeImageUseCaseImpl: UploadCakeImageUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods

  public func execute(cakeShopId: Int, image: UIImage, categories: [CakeCategory], tags: [String]) -> AnyPublisher<Void, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.uploadCakeImage(cakeShopId: cakeShopId, image: image, categories: categories, tags: tags, accessToken: accessToken)
        .eraseToAnyPublisher()
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}

