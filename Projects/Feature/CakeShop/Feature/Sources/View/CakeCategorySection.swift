//
//  CakeCategorySection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DomainCakeShop
import Router

struct CakeCategorySection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 16) {
      SectionHeaderLarge(title: "종류별로 보기")
        .padding(.horizontal, 16)
      
      categoryItemGrid(horizontalSizeClass: horizontalSizeClass)
        .padding(.horizontal, 20)
    }
    .background(Color.white)
  }
  
  private func categoryItem(category: CakeCategory) -> some View {
    Button {
      router.navigate(to: Destination.categoryDetail(initialCategory: category))
    } label: {
      VStack(spacing: 8) {
        RoundedRectangle(cornerRadius: 20)
          .fill(DesignSystemAsset.gray10.swiftUIColor)
          .frame(width: 52, height: 52)
          .overlay {
            Text(category.emoji)
              .font(.system(size: 24))
          }
        
        Text(category.displayName)
          .font(.pretendard(size: 13, weight: .medium))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          .lineLimit(1)
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  @ViewBuilder
  private func categoryItemGrid(horizontalSizeClass: UserInterfaceSizeClass?) -> some View {
    if horizontalSizeClass == .compact {
      let columns: [GridItem] = .init(repeating: .init(.adaptive(minimum: 76), alignment: .center), count: 5)
      LazyVGrid(columns: columns, spacing: 22, content: {
        ForEach(CakeCategory.allCases, id: \.id) { category in
          categoryItem(category: category)
        }
      })
      .frame(height: 180)
    } else {
      ScrollView(.horizontal) {
        HStack(spacing: 22) {
          ForEach(CakeCategory.allCases, id: \.id) { category in
            categoryItem(category: category)
          }
        }
      }
    }
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    CakeCategorySection()
  }
}

extension CakeCategory: Identifiable {
  public var id: String {
    return displayName
  }
  
  var displayName: String {
    switch self {
    case .threeDimensional: "입체"
    case .character: "캐릭터"
    case .photo: "포토"
    case .lunchbox: "도시락"
    case .figure: "피규어"
    case .flower: "플라워"
    case .lettering: "레터링"
    case .riceCake: "떡케이크"
    case .tiara: "티아라"
    case .etc: "기타"
    }
  }
  
  var emoji: String {
    switch self {
    case .threeDimensional: "🐰"
    case .character: "🧸"
    case .photo: "📷"
    case .lunchbox: "🍱"
    case .figure: "🤖"
    case .flower: "🌷"
    case .lettering: "✍️"
    case .riceCake: "🍚"
    case .tiara: "👑"
    case .etc: "🍰"
    }
  }
}
