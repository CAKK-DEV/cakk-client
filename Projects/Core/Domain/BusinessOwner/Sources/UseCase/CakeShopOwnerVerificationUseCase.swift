//
//  CakeShopOwnerVerificationUseCase.swift
//  DomainBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

public protocol CakeShopOwnerVerificationUseCase {
  func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, BusinessOwnerError>
}
