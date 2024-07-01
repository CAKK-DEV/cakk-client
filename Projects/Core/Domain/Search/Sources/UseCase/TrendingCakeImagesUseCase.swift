//
//  TrendingCakeImagesUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 7/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol TrendingCakeImagesUseCase {
  func execute(lastImageId: Int?, pageSize: Int) -> AnyPublisher<[CakeImage], Error>
}
