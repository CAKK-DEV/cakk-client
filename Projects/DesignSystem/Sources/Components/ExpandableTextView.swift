//
//  ExpandableTextView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import SwiftUIUtil

public struct ExpandableTextView: View {
  
  // MARK: - Properties
  
  private let text: String
  private let font: Font
  private let lineLimit: Int
  
  @State private var isExpanded: Bool = false
  @State private var isTruncated: Bool? = nil
  
  
  // MARK: - Initializers
  
  public init(
    text: String,
    font: Font = .pretendard(size: 15),
    lineLimit: Int = 3
  ) {
    self.text = text
    self.font = font
    self.lineLimit = lineLimit
  }
  
  
  // MARK: - Views
  
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(text)
        .font(font)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(isExpanded ? nil : lineLimit)
        .background(calculateTruncation(text: text))
      
      if isTruncated == true {
        Button {
          withoutAnimation {
            isExpanded.toggle()
          }
        } label: {
          HStack {
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            Text(isExpanded ? "접기" : "더보기")
          }
          .font(font)
        }
        .animation(nil, value: isExpanded)
        .buttonStyle(PlainButtonStyle())
      }
    }
    .multilineTextAlignment(.leading)
    .onChange(of: text, perform: { _ in isTruncated = nil })
  }
  
  func calculateTruncation(text: String) -> some View {
    ViewThatFits(in: .vertical) {
      Text(text)
        .hidden()
        .onAppear {
          guard isTruncated == nil else { return }
          isTruncated = false
        }
      Color.clear
        .hidden()
        .onAppear {
          guard isTruncated == nil else { return }
          isTruncated = true
        }
    }
  }
}


// MARK: - Preview

#Preview {
  ExpandableTextView(text: """
  long text long text long text long text long text
  long text long text long text
  long text long text long text long text long text
  long text long text long text long text long text
  """
  )
}
