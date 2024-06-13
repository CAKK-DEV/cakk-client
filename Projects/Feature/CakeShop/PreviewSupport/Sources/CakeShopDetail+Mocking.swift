//
//  CakeShopDetail+Mocking.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//
import Foundation
import DomainCakeShop

extension CakeShopDetail {
  static var mock: Self {
    return .init(
      shopId: "0",
      shopName: "맛있다 케이크샵",
      thumbnailImageUrl: "https://mblogthumb-phinf.pstatic.net/MjAyMzAyMjdfNTYg/MDAxNjc3NDI4ODkxNzg4.XxxPeBm9ltiL0iF2h0ikAzdG81pEMB4Tp-ORexO6NFog.e4zEIRUMalaHP29ukMhnfC-VtkPRZZLr-jTqXYp3ArUg.JPEG.thsldpswpf0112/%EB%B4%87%EC%B9%982.jpg?type=w800",
      shopBio: """
      우리는 항상 최고의 재료만을 사용하여 고객들에게 최고의 맛을 제공합니다.
      다양한 디자인과 맛으로 모든 고객의 취향을 만족시킬 수 있습니다.
      생일, 기념일, 특별한 날에 우리 케이크로 행복을 나누세요.
      """,
      shopDescription: """
      안녕하세요 맛있다 케이크 입니다💕 
      
      간편주문 디자인 외에는 커스텀 디자인으로
      사진첨부 후 주문 해주시면 됩니다☺
      
      ✔️타디자인 또는 디자인 샘플
      완벽하게 똑같이는 어려워요 참고 부탁드립니다
      
      최대한 비슷하게 제작 해드리겠습니다☺️
      
      ❤작업시간 외에는 무인픽업으로 진행 됩니다
      
      ❤시간이 정해져 있지는 않아서 작업 후 무인픽업 안내메세지 보내드리고 있습니다
      """,
      workingDays: [.tue, .thu, .fri, .sat, .sun],
      externalShopLinks: [
        ExternalShopLink(linkType: .instagram, linkPath: "https://instagram.com/mock"),
        ExternalShopLink(linkType: .web, linkPath: "https://web.com/mock")
      ]
    )
  }
}
