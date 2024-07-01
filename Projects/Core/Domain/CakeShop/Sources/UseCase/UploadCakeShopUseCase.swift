//
//  UploadCakeShopUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol UploadCakeShopUseCase {
  func execute(name: String, bio: String?, description: String?, businessNumber: String?, address: String, latitude: Double, longitude: Double, workingDaysWithTime: [WorkingDayWithTime], externalLinks: [ExternalShopLink]) -> AnyPublisher<Void, CakeShopError>
}
