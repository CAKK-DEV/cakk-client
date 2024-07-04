//
//  TrendingCakeImagesUseCaseImpl.swift
//  NetworkSearch
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainSearch

public final class TrendingCakeImagesUseCaseImpl: TrendingCakeImagesUseCase {
  
  
  // MARK: - Properties
  
  private let repository: SearchRepository
  
  
  // MARK: - Initializers
  
  public init(repository: SearchRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(lastImageId: Int?, pageSize: Int) -> AnyPublisher<[CakeImage], any Error> {
    repository.fetchCakeImages(keyword: nil, latitude: nil, longitude: nil, pageSize: pageSize, lastCakeId: lastImageId)
  }
}
