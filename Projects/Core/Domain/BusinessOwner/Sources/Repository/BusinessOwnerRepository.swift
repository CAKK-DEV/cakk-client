//
//  BusinessOwnerRepository.swift
//  DomainBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

public protocol BusinessOwnerRepository {
  func requestCakeShopOwnerVerification(shopId: Int, businessRegistrationImageUrl: String, idCardImageUrl: String, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, BusinessOwnerError>
}
