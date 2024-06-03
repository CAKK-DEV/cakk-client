//
//  FlexibleGridView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/3/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct FlexibleGridView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
  
  // MARK: - Properties
  
  let verticalSpacing: CGFloat
  let horizontalSpacing: CGFloat
  let columns: Int
  let data: Data
  let content: (Data.Element) -> Content
  
  @State private var alignmentGuides = [AnyHashable: CGPoint]()
  @State private var gridHeight: CGFloat = 0
  
  
  // MARK: - Initializers
  
  public init(columns: Int = 2, verticalSpacing: CGFloat = 8, horizontalSpacing: CGFloat = 8, data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.columns = columns
    self.verticalSpacing = verticalSpacing
    self.horizontalSpacing = horizontalSpacing
    self.data = data
    self.content = content
  }
  
  // MARK: - Views
  
  public var body: some View {
    HStack(alignment: .top, spacing: horizontalSpacing) {
      ForEach(splitData.indices, id: \.self) { index in
        LazyVStack(spacing: verticalSpacing) {
          ForEach(splitData[index]) { item in
            content(item)
              .background(PreferenceSetter(id: item.id))
              .alignmentGuide(.top, computeValue: { _ in self.alignmentGuides[item.id]?.y ?? 0 })
              .alignmentGuide(.leading, computeValue: { _ in self.alignmentGuides[item.id]?.x ?? 0 })
              .opacity(self.alignmentGuides[item.id] != nil ? 1 : 0)
              .animation(.spring(), value: item.id)
          }
        }
      }
    }
    .onPreferenceChange(ElementPreferenceKey.self) { preferences in
      DispatchQueue.global(qos: .userInteractive).async {
        let (alignmentGuides, gridHeight) = self.alignmentsAndGridHeight(preferences: preferences)
        DispatchQueue.main.async {
          self.alignmentGuides = alignmentGuides
          self.gridHeight = gridHeight
        }
      }
    }
  }
  
  private func alignmentsAndGridHeight(preferences: [ElementPreferenceData]) -> ([AnyHashable: CGPoint], CGFloat) {
    var heights = Array(repeating: CGFloat(0), count: columns)
    var alignmentGuides = [AnyHashable: CGPoint]()
    
    preferences.forEach { preference in
      if let minValue = heights.min(), let indexMin = heights.firstIndex(of: minValue) {
        let width = preference.size.width * CGFloat(indexMin) + CGFloat(indexMin) * horizontalSpacing
        let height = heights[indexMin]
        let offset = CGPoint(x: 0 - width, y: 0 - height)
        heights[indexMin] += preference.size.height + verticalSpacing
        alignmentGuides[preference.id] = offset
      }
    }
    
    let gridHeight = max(0, (heights.max() ?? verticalSpacing) - verticalSpacing)
    
    return (alignmentGuides, gridHeight)
  }
  
  
  // MARK: - Private Methods
  
  private var splitData: [[Data.Element]] {
    var columnsData = Array(repeating: [Data.Element](), count: columns)
    for (index, item) in data.enumerated() {
      columnsData[index % columns].append(item)
    }
    return columnsData
  }
}


// MARK: - ElementPreferenceKey

private struct ElementPreferenceKey: PreferenceKey {
  typealias Value = [ElementPreferenceData]
  
  static var defaultValue: [ElementPreferenceData] = []
  
  static func reduce(value: inout [ElementPreferenceData], nextValue: () -> [ElementPreferenceData]) {
    value.append(contentsOf: nextValue())
  }
}

private struct ElementPreferenceData: Equatable {
  let id: AnyHashable
  let size: CGSize
}

private struct PreferenceSetter: View {
  let id: AnyHashable
  
  var body: some View {
    GeometryReader { geometry in
      Color.clear
        .preference(key: ElementPreferenceKey.self, value: [ElementPreferenceData(id: self.id, size: geometry.size)])
    }
  }
}


// MARK: - Preview

private struct Preview_ContentView: View {
  struct Item: Identifiable {
    let id: Int
    let height: CGFloat
  }
  
  let items = (1...10).map { Item(id: $0, height: CGFloat.random(in: 150...300)) }
  
  var body: some View {
    ScrollView {
      FlexibleGridView(columns: 2, data: items) { item in
        RoundedRectangle(cornerRadius: 14)
          .foregroundStyle(Color.gray.opacity(0.2))
          .frame(height: item.height)
          .overlay {
            Text(item.id.description)
          }
      }
    }
  }
}

#Preview {
  Preview_ContentView()
}
