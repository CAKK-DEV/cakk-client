//
//  EditCakeShopExternalLInkUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop
import UserSession

public final class EditCakeShopExternalLInkUseCaseImpl: EditExternalLinkUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?) -> AnyPublisher<Void, CakeShopError> {
    if let accessToken = UserSession.shared.accessToken {
      repository.editExternalLink(cakeShopId: cakeShopId, instaUrl: instaUrl, kakaoUrl: kakaoUrl, webUrl: webUrl, accessToken: accessToken)
    } else {
      Fail(error: CakeShopError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
