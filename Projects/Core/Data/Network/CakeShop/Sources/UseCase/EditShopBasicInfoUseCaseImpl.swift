//
//  EditShopBasicInfoUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import UserSession

import NetworkImage

public final class EditShopBasicInfoUseCaseImpl: EditShopBasicInfoUseCase {
  
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
  
  public func execute(cakeShopId: Int, newCakeShopBasicInfo: NewCakeShopBasicInfo) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      switch newCakeShopBasicInfo.profileImage {
      case .delete, .none:
        cakeShopRepository.editShopBasicInfo(shopId: cakeShopId,
                                             profileImageUrl: nil,
                                             shopName: newCakeShopBasicInfo.shopName,
                                             shopBio: newCakeShopBasicInfo.shopBio,
                                             shopDescription: newCakeShopBasicInfo.shopDescription,
                                             accessToken: accessToken)
        
      case .new(let image):
        imageUploadRepository.uploadImage(image: image)
          .mapError { error in
            switch error {
            case .imageConvertError, .failure:
              return CakeShopError.imageUploadFailure
            }
          }
          .flatMap { [cakeShopRepository] imageUrl in
            cakeShopRepository.editShopBasicInfo(shopId: cakeShopId,
                                                 profileImageUrl: imageUrl,
                                                 shopName: newCakeShopBasicInfo.shopName,
                                                 shopBio: newCakeShopBasicInfo.shopBio,
                                                 shopDescription: newCakeShopBasicInfo.shopDescription,
                                                 accessToken: accessToken)
          }
          .eraseToAnyPublisher()
        
      case .original(let imageUrl):
        cakeShopRepository.editShopBasicInfo(shopId: cakeShopId,
                                             profileImageUrl: imageUrl,
                                             shopName: newCakeShopBasicInfo.shopName,
                                             shopBio: newCakeShopBasicInfo.shopBio,
                                             shopDescription: newCakeShopBasicInfo.shopDescription,
                                             accessToken: accessToken)
      }
      
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
