//
//  CKSegmentedControl.swift
//  DesignSystem
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil

public struct CKSegmentedControl: View {
  
  // MARK: - Properties
  
  private var items: [CKSegmentItem]
  @Binding private var selection: CKSegmentItem
  
  private let sizeOption: SizeOption
  public enum SizeOption {
    case compact
    case regular
  }
  
  @Namespace private var namespace
  
  
  // MARK: - Initializers
  
  public init(
    items: [CKSegmentItem],
    selection: Binding<CKSegmentItem>,
    size: SizeOption = .regular
  ) {
    self.items = items
    _selection = selection
    self.sizeOption = size
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    HStack(spacing: 20) {
      ForEach(items, id: \.self) { item in
        Text(item.title)
          .font(.pretendard(size: 15, weight: .bold))
          .foregroundStyle(selection == item
                           ? DesignSystemAsset.black.swiftUIColor
                           : DesignSystemAsset.gray50.swiftUIColor)
          .frame(maxWidth: .infinity)
          .frame(height: sizeOption == .regular ? 60 : 40)
          .contentShape(Rectangle())
          .overlay {
            if selection == item {
              VStack(spacing: 0) {
                Spacer()
                Capsule()
                  .fill(DesignSystemAsset.black.swiftUIColor)
                  .frame(width: 84, height: 2)
                  .matchedGeometryEffect(id: "indicator", in: namespace)
              }
            }
          }
          .onTapGesture {
            withAnimation(.snappy(duration: 0.34)) {
              selection = item
            }
          }
      }
    }
    .padding(.horizontal, 28)
    .background {
      VStack(spacing: 0) {
        Spacer()
        Rectangle()
          .fill(DesignSystemAsset.gray20.swiftUIColor)
          .frame(height: 1)
      }
    }
    .background(Color.white)
    .frame(maxWidth: .infinity)
  }
}


// MARK: - Preview

#Preview {
  struct PreviewContent: View {
    private let items: [CKSegmentItem]
    @State private var selection: CKSegmentItem
    
    init() {
      let item1 = CKSegmentItem(title: "item1")
      let item2 = CKSegmentItem(title: "item2")
      items = [item1, item2]
      selection = item1
    }
    
    var body: some View {
      ZStack {
        Color.gray.ignoresSafeArea()
        
        VStack {
          CKSegmentedControl(items: items, selection: $selection)
          CKSegmentedControl(items: items, selection: $selection, size: .compact)
        }
      }
    }
  }
  
  return PreviewContent()
}
