//
//  CakeImageDetail+Mocking.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeImageDetail {
  static func mock() -> CakeImageDetail {
    return .init(shopId: 0,
                 imageUrl: "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                 shopBio: "행복한 케이크",
                 categories: [.lettering, .etc],
                 tags: ["짱구", "액션가면", "떡잎마을"])
  }
}
