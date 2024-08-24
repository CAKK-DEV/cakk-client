//
//  CategorySelectionNavigationView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import CommonUtil
import DIContainer
import LinkNavigator

import CommonDomain
import DomainCakeShop

struct CategorySelectionNavigationView: View {
  
  // MARK: - Properties
  
  @Binding var selection: CakeCategory
  @Namespace private var namespace
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init(selection: Binding<CakeCategory>) {
    _selection = selection
    
    let container = DIContainer.shared.container
    self.navigator = container.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    return HStack {
      Button {
        navigator?.back(isAnimated: true)
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
              .onTapGesture {
                UISelectionFeedbackGenerator().selectionChanged()
                withAnimation(.snappy) {
                  selection = category
                }
              }
            }
          }
          .padding(.horizontal, 20)
        }
        .animation(.snappy, value: selection)
        .onChange(of: selection) { _ in
          withAnimation {
            value.scrollTo(selection, anchor: .center)
          }
        }
        .onFirstAppear {
          withoutAnimation {
            value.scrollTo(selection, anchor: .center)
          }
        }
      }
      .overlay {
        HStack {
          LinearGradient(colors:[Color.white, Color.clear], startPoint: .leading, endPoint: .trailing)
            .frame(width: 24)
          Spacer()
        }
      }
      .clipShape(Capsule())
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
