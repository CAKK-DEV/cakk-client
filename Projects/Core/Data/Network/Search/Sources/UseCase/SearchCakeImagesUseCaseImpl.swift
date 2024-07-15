//
//  SearchCakeImagesUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/16/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainSearch

public final class SearchCakeImagesUseCaseImpl: SearchCakeImagesUseCase {
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(keyword: String?, latitude: Double?, longitude: Double?, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], any Error> {
    repository.fetchCakeImages(keyword: keyword, latitude: latitude, longitude: longitude, pageSize: pageSize, lastCakeId: lastCakeId)
  }
}
