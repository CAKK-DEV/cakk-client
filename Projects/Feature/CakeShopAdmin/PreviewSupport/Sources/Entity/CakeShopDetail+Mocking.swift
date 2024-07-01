//
//  CakeShopDetail+Mocking.swift
//  PreviewSupportCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

public extension CakeShopDetail {
  static func mock() -> CakeShopDetail {
    return .init(shopId: 0,
                 shopName: "맛있다 케이크샵",
                 thumbnailImageUrl: "https://mblogthumb-phinf.pstatic.net/MjAyMzAyMjdfNTYg/MDAxNjc3NDI4ODkxNzg4.XxxPeBm9ltiL0iF2h0ikAzdG81pEMB4Tp-ORexO6NFog.e4zEIRUMalaHP29ukMhnfC-VtkPRZZLr-jTqXYp3ArUg.JPEG.thsldpswpf0112/%EB%B4%87%EC%B9%982.jpg?type=w800",
                 shopBio: "케이크샵 한 줄 소개",
                 shopDescription: "케이크샵 상세 소개",
                 workingDays: [.sun, .wed, .thu, .fri, .sat],
                 externalShopLinks: [
                  .init(linkType: .instagram, linkPath: "https://www.instagram.com/cakeke_ke?igsh=MWM2ZXN6MjRncHhvbw%3D%3D&utm_source=qr"),
                  .init(linkType: .web, linkPath: "https://www.notion.so/8d449787674c4399afcc55ef9661313c?pvs=4")
                 ])
  }
}
