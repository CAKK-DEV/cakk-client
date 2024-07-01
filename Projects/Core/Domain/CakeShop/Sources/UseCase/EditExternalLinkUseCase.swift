//
//  EditExternalLinkUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/26/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol EditExternalLinkUseCase {
  func execute(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?) -> AnyPublisher<Void, CakeShopError>
}
