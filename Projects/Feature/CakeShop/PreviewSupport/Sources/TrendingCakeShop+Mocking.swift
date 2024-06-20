//
//  TrendingCakeShop+Mocking.swift
//  PreviewSupportCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension TrendingCakeShop {
  static let mockCakeShops: [TrendingCakeShop] = [
    TrendingCakeShop(shopId: 1,
                     profileImageUrl: "https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDd8fGNha2V8ZW58MHx8MHx8fDA%3D",
                     name: "스스드드",
                     bio: "연예인케이크◦커스텀케이크◦생화케이크",
                     cakeImageUrls: [
                      "https://images.unsplash.com/photo-1604413191066-4dd20bedf486?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDZ8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1566121933407-3c7ccdd26763?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTR8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1615735487485-e52b9af610c1?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTV8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1612809075925-230725151da2?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjR8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1618426703623-c1b335803e07?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Njh8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1557925923-33b27f891f88?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzF8fGNha2V8ZW58MHx8MHx8fDA%3D"
                     ]),
    TrendingCakeShop(shopId: 2,
                     profileImageUrl: "https://images.unsplash.com/photo-1567009349827-ab242f2c96e6?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE1fHxjYWtlfGVufDB8fDB8fHww",
                     name: "크래프트 케이크",
                     bio: "더 크래프트 커스텀 디자인 케이크",
                     cakeImageUrls: [
                      "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODB8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1608830597604-619220679440?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1558234469-50fc184d1cc9?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODR8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1624000961428-eeece184988b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODd8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1629389861081-43cc4f172b0c?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODZ8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1562023693-ca3a992c9ea6?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OTJ8fGNha2V8ZW58MHx8MHx8fDA%3D"
                     ]),
    TrendingCakeShop(shopId: 3,
                     profileImageUrl: "https://images.unsplash.com/photo-1557308536-ee471ef2c390?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDB8fGNha2V8ZW58MHx8MHx8fDA%3D",
                     name: "유니온 케이크",
                     bio: "커스텀케이크 제작 / 케이크 원데이 클래스 / 케이크 키트박스 도시락 어쩌구 저쩌구",
                     cakeImageUrls: [
                      "https://plus.unsplash.com/premium_photo-1664205765598-85bfc3f61942?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjV8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1595272568891-123402d0fb3b?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1559620192-032c4bc4674e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1607478900766-efe13248b125?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://plus.unsplash.com/premium_photo-1664205766193-46193f865ae1?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjF8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1488477304112-4944851de03d?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGNha2V8ZW58MHx8MHx8fDA%3D"
                     ]),
    TrendingCakeShop(shopId: 4,
                     profileImageUrl: "https://images.unsplash.com/photo-1562777717-dc6984f65a63?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGNha2V8ZW58MHx8MHx8fDA%3D",
                     name: "포실 케이크",
                     bio: "포싵｜연희동 케이크 • 빈티지케이크 • 커스텀케이크",
                     cakeImageUrls: [
                      "https://images.unsplash.com/photo-1558301211-0d8c8ddee6ec?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1542826438-bd32f43d626f?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGNha2V8ZW58MHx8MHx8fDA%3D",
                      "https://images.unsplash.com/photo-1602351447937-745cb720612f?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNha2V8ZW58MHx8MHx8fDA%3D"
                     ]),
  ]
}
