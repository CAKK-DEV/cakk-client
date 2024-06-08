//
//  CakeShopQuickInfo+Mocking.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension CakeShopQuickInfo {
  static var mock: Self {
    .init(
      shopId: 0,
      shopName: "미쁘다 케이크",
      shopBio: "미쁘다케이크🍰_레터링케이크 주문제작케이크 남양주레터링케이크 커스텀케이크",
      thumbnailUrl: "https://ichef.bbci.co.uk/news/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg.webp")
  }
}
