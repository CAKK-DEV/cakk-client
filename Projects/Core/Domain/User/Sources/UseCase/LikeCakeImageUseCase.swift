//
//  LikeUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 6/18/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol LikeCakeImageUseCase {
  func fetchLikedCakeImages(lastImageId: Int?, pageSize: Int) -> AnyPublisher<[LikedCakeImage], LikeError>
  func likeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError>
  func unlikeCakeImage(imageId: Int) -> AnyPublisher<Void, LikeError>
  func fetchCakeImageLikedState(imageId: Int) -> AnyPublisher<Bool, LikeError>
}
