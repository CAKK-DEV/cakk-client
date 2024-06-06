//
//  CategorySelectionNavigationView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DomainCakeShop
import Router

struct CategorySelectionNavigationView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @Binding var selection: CakeCategory
  @Namespace private var namespace
  
  
  // MARK: - Views
  
  var body: some View {
    HStack {
      Button {
        router.navigateBack()
      } label: {
        Image(systemName: "arrow.left")
          .font(.system(size: 20))
          .foregroundColor(DesignSystemAsset.black.swiftUIColor)
      }
      .padding(.leading, 16)
       
      ScrollViewReader { value in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(CakeCategory.allCases, id: \.self) { category in
              Button {
                withAnimation(.spring(duration: 0.3, bounce: 0.145, blendDuration: 1)) {
                  selection = category
                  value.scrollTo(category, anchor: .center)
                }
              } label: {
                let isSelected = selection == category
                ZStack {
                  if isSelected {
                    Capsule()
                      .fill(DesignSystemAsset.black.swiftUIColor)
                      .frame(height: 38)
                      .matchedGeometryEffect(id: "selection_capsule", in: namespace)
                  }
                  
                  Text(category.displayName)
                    .font(.pretendard(size: 15, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .white : DesignSystemAsset.black.swiftUIColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .clipShape(Capsule())
                }
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          .padding(.horizontal, 20)
        }
        .onAppear {
          withoutAnimation {
            value.scrollTo(selection, anchor: .center)
          }
        }
      }
      .overlay {
        HStack {
          LinearGradient(colors:[Color.white, Color.white, Color.clear], startPoint: .leading, endPoint: .trailing)
            .frame(width: 24)
          Spacer()
        }
      }
    }
    .frame(maxWidth: .infinity, minHeight: 52)
    .background(Color.white)
    .overlay {
      VStack(spacing: 0) {
        Spacer()
        Rectangle()
          .fill(DesignSystemAsset.gray20.swiftUIColor)
          .frame(maxWidth: .infinity, maxHeight: 1)
      }
    }
  }
}


// MARK: - Preview

#Preview {
  struct Preview: View {
    @State var selection: CakeCategory = .threeDimensional
    
    var body: some View {
      ZStack {
        Color.black.ignoresSafeArea()
        CategorySelectionNavigationView(selection: $selection)
      }
    }
  }
  
  return Preview()
}
