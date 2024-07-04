//
//  UploadcakeShopUseCaseImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainCakeShop

public final class UploadCakeShopUseCaseImpl: UploadCakeShopUseCase {
  
  // MARK: - Properties
  
  private let repository: CakeShopRepository
  
  
  // MARK: - Initializers
  
  public init(repository: CakeShopRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(name: String, bio: String?, description: String?, businessNumber: String?, address: String, latitude: Double, longitude: Double, workingDaysWithTime: [WorkingDayWithTime], externalLinks: [ExternalShopLink]) -> AnyPublisher<Void, CakeShopError> {
    repository.uploadCakeShop(name: name,
                              bio: bio,
                              description: description,
                              businessNumber: businessNumber,
                              address: address,
                              latitude: latitude,
                              longitude: longitude, 
                              workingDaysWithTime: workingDaysWithTime,
                              externalLinks: externalLinks)
  }
}
