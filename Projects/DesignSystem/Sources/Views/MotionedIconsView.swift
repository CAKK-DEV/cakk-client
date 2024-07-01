//
//  MotionedIconsView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public struct MotionedIconsView: View {
  
  // MARK: - Properties
  
  @StateObject private var motionData = MotionObserver()
  private let isMotionActivated: Bool
  
  @State private var rowParticleRepeating = 5
  @State private var rowRepeating: Int
  

  // MARK: - Initializers
  
  public init(
    rowRepeating: Int = 3,
    isMotionActivated: Bool = true
  ) {
    self.rowRepeating = rowRepeating
    self.isMotionActivated = isMotionActivated
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    LazyVStack(spacing: -16) {
      ForEach(0..<rowRepeating, id: \.self) { index in
        iconsRowSet()
          .offset(x: index % 2 == 0 ? -32 : 0)
      }
    }
    .offset(motionData.movingOffset)
    .background {
      GeometryReader { proxy in
        Color.clear.onAppear {
          rowParticleRepeating = Int(proxy.size.width) % 162 / 2
        }
      }
    }
    .onAppear {
      if isMotionActivated {
        motionData.fetchMotionData(duration: 15)
      }
    }
  }
  
  private func iconsRowSet() -> some View {
    VStack {
      iconsRow1()
      iconsRow2()
      iconsRow3()
      iconsRow4()
    }
  }
  
  private func iconsRow1() -> some View {
    LazyHStack(spacing: 76) {
      ForEach(0..<rowParticleRepeating, id: \.self) { _ in
        DesignSystemAsset.circleSmall.swiftUIImage
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(.white.opacity(0.6))
      }
    }
  }
  
  private func iconsRow2() -> some View {
    LazyHStack(spacing: 76) {
      ForEach(0..<rowParticleRepeating, id: \.self) { _ in
        DesignSystemAsset.cupcake.swiftUIImage
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(.white.opacity(0.6))
          .rotationEffect(.degrees(10))
          .offset(x: 34, y: -16)
      }
    }
  }
  
  private func iconsRow3() -> some View {
    LazyHStack(spacing: 76) {
      ForEach(0..<rowParticleRepeating, id: \.self) { _ in
        DesignSystemAsset.circleQuarter.swiftUIImage
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(.white.opacity(0.6))
          .rotationEffect(.degrees(10))
          .offset(x: -20, y: -20)
      }
    }
  }
  
  private func iconsRow4() -> some View {
    LazyHStack(spacing: 40) {
      ForEach(0..<rowParticleRepeating, id: \.self) { _ in
        HStack(spacing: 16) {
          DesignSystemAsset.cakeSlice.swiftUIImage
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(.white.opacity(0.6))
            .rotationEffect(.degrees(-16))
          
          DesignSystemAsset.starOctogram.swiftUIImage
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(.white.opacity(0.6))
            .rotationEffect(.degrees(-16))
        }
        .offset(x: 24, y: -28)
      }
    }
  }
}


// MARK: - Preview

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    MotionedIconsView()
  }
}
