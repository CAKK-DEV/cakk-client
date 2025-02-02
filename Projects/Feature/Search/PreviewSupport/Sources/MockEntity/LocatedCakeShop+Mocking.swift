//
//  LocatedCakeShop+Mocking.swift
//  PreviewSupportSearch
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainSearch
extension LocatedCakeShop {
  static let mockCakeShops: [LocatedCakeShop] = [
    LocatedCakeShop(
      id: 1,
      profileImageUrl: "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      name: "달콤한 간식 베이커리",
      bio: "신선한 케이크와 페이스트리를 매일 제공합니다.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?q=80&w=1350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://plus.unsplash.com/premium_photo-1671212748162-d7bdb9d4f5ec?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D",
        "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D"
      ],
      longitude: 127.0327,
      latitude: 37.4994
    ),
    LocatedCakeShop(
      id: 2,
      profileImageUrl: "https://images.unsplash.com/photo-1562440499-64c9a111f713?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      name: "해피 케이크샵",
      bio: "고객님의 특별한 날을 위한 맞춤 케이크를 제작합니다.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1562440499-64c9a111f713?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1621303837174-89787a7d4729?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y2FrZXxlbnwwfHwwfHx8MA%3D%3D",
        "https://images.unsplash.com/photo-1602351447937-745cb720612f?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0302,
      latitude: 37.4973
    ),
    LocatedCakeShop(
      id: 3,
      profileImageUrl: "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      name: "달콤한 하루",
      bio: "매일 신선한 재료로 만든 건강한 케이크.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1557308536-ee471ef2c390?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDB8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1616690710400-a16d146927c5?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDN8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0278,
      latitude: 37.4979
    ),
    LocatedCakeShop(
      id: 4,
      profileImageUrl: "https://images.unsplash.com/photo-1557925923-33b27f891f88?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzF8fGNha2V8ZW58MHx8MHx8fDA%3D",
      name: "행복한 케이크",
      bio: "모든 기념일을 더욱 특별하게 만드는 케이크.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1557925923-33b27f891f88?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzF8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1542826438-bd32f43d626f?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://plus.unsplash.com/premium_photo-1665218519906-095288172c93?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1558301211-0d8c8ddee6ec?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0300,
      latitude: 37.4987
    ),
    LocatedCakeShop(
      id: 5,
      profileImageUrl: "https://images.unsplash.com/photo-1549312142-d1b299cfe034?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTAzfHxjYWtlfGVufDB8fDB8fHww",
      name: "디저트 파라다이스",
      bio: "다양한 디저트와 케이크를 즐길 수 있는 천국.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1549312142-d1b299cfe034?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTAzfHxjYWtlfGVufDB8fDB8fHww",
        "https://images.unsplash.com/photo-1567009349827-ab242f2c96e6?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE1fHxjYWtlfGVufDB8fDB8fHww",
        "https://images.unsplash.com/photo-1624000961428-eeece184988b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODd8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1618426703623-c1b335803e07?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Njh8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0308,
      latitude: 37.5005
    ),
    LocatedCakeShop(
      id: 6,
      profileImageUrl: "https://images.unsplash.com/photo-1608830597604-619220679440?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
      name: "러블리 케이크샵",
      bio: "사랑스러운 디자인과 맛있는 케이크를 제공합니다.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1608830597604-619220679440?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1558234469-50fc184d1cc9?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODR8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1562023693-ca3a992c9ea6?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OTJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1611293388250-580b08c4a145?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OTF8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0283,
      latitude: 37.4967
    ),
    LocatedCakeShop(
      id: 7,
      profileImageUrl: "https://images.unsplash.com/photo-1566121933407-3c7ccdd26763?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTR8fGNha2V8ZW58MHx8MHx8fDA%3D",
      name: "카페 앤 케이크",
      bio: "커피와 함께 즐기는 다양한 케이크.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1566121933407-3c7ccdd26763?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTR8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1615735487485-e52b9af610c1?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTV8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1612809075925-230725151da2?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjR8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1618426703623-c1b335803e07?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Njh8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0294,
      latitude: 37.4972
    ),
    LocatedCakeShop(
      id: 8,
      profileImageUrl: "https://images.unsplash.com/photo-1618451615316-5d492a2323a2?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OTh8fGNha2V8ZW58MHx8MHx8fDA%3D",
      name: "하늘 케이크",
      bio: "구름처럼 부드럽고 맛있는 케이크를 만듭니다.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1618451615316-5d492a2323a2?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OTh8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODB8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1608830597604-619220679440?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1558234469-50fc184d1cc9?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODR8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0311,
      latitude: 37.4998
    ),
    LocatedCakeShop(
      id: 9,
      profileImageUrl: "https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDR8fGNha2V8ZW58MHx8MHx8fDA%3D",
      name: "바닐라 베이커리",
      bio: "고소한 바닐라향이 가득한 케이크 전문점.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDR8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDd8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1604413191066-4dd20bedf486?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDZ8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1566121933407-3c7ccdd26763?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTR8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0280,
      latitude: 37.4990
    ),
    LocatedCakeShop(
      id: 10,
      profileImageUrl: "https://images.unsplash.com/photo-1559620192-032c4bc4674e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      name: "초코홀릭",
      bio: "진한 초콜릿 케이크로 유명한 디저트샵.",
      cakeImageUrls: [
        "https://images.unsplash.com/photo-1559620192-032c4bc4674e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://plus.unsplash.com/premium_photo-1664205765598-85bfc3f61942?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjV8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1616690710400-a16d146927c5?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDN8fGNha2V8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNha2V8ZW58MHx8MHx8fDA%3D"
      ],
      longitude: 127.0319,
      latitude: 37.4985
    )
  ]
}
