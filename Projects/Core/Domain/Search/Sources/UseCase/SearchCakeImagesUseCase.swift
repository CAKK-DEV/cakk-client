//
//  SearchCakeImagesUseCase.swift
//  DomainSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SearchCakeImagesUseCase {
  func execute(keyword: String?, latitude: Double, longitude: Double, pageSize: Int, lastCakeId: Int?) -> AnyPublisher<[CakeImage], Error>
}
