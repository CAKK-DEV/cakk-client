//
//  UploadCakeImageUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

public protocol UploadCakeImageUseCase {
  func execute(cakeShopId: Int, image: UIImage, categories: [CakeCategory], tags: [String]) -> AnyPublisher<Void, CakeShopError>
}
