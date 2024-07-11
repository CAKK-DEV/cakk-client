//
//  UploadCakeImageUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import CommonDomain
import DomainCakeShop

import NetworkImage

import UserSession

public final class UploadCakeImageUseCaseImpl: UploadCakeImageUseCase {
  
  // MARK: - Properties
  
  private let cakeShopRepository: CakeShopRepository
  private let imageUploadRepository: ImageUploadRepository
  
  
  // MARK: - Initializers
  
  public init(
    cakeShopRepository: CakeShopRepository,
    imageUploadRepository: ImageUploadRepository
  ) {
    self.cakeShopRepository = cakeShopRepository
    self.imageUploadRepository = imageUploadRepository
  }
  
  
  // MARK: - Public Methods

  public func execute(cakeShopId: Int, image: UIImage, categories: [CakeCategory], tags: [String]) -> AnyPublisher<Void, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      imageUploadRepository.uploadImage(image: image)
        .mapError { error in
          switch error {
          case .imageConvertError, .failure:
            return CakeShopError.imageUploadFailure
          }
        }
        .flatMap { [cakeShopRepository] imageUrl in
          cakeShopRepository.uploadCakeImage(cakeShopId: cakeShopId, imageUrl: imageUrl, categories: categories, tags: tags, accessToken: accessToken)
        }
        .eraseToAnyPublisher()
      
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}

