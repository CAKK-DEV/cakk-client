//
//  CakeImageGridItem.swift
//  DesignSystem
//
//  Created by 이승기 on 7/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Kingfisher
import CommonUtil

public struct CakeImageGridItem: View {
  
  // MARK: - Properties
  
  private let imageUrlString: String
  @StateObject private var viewModel: CakeImageGridItemViewModel
  @State private var imageSize: CGSize = .zero
  
  // MARK: - Initializers
  
  public init(imageUrlString: String) {
    self.imageUrlString = imageUrlString
    _viewModel = StateObject(wrappedValue: CakeImageGridItemViewModel())
  }
  
  
  // MARK: - Public Methods
  
  public var body: some View {
    Group {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .background {
            /// 한 번 불러온 이미지의 사이즈를 저장합니다.
            /// 최적화를 위해서 이미지가 메모리에서 해제되는 경우 기존 이미지 사이즈만큼 placeholder의 사이즈를 유지하기 위함입니다.
            GeometryReader { proxy in
              Color.clear
                .onAppear {
                  let _ = imageSize = proxy.size
                }
            }
          }
      } else {
        DesignSystemAsset.gray10.swiftUIColor
          .frame(width: imageSize != .zero ? imageSize.width : nil,
                 height: imageSize != .zero ? imageSize.height : nil)
          .aspectRatio(1, contentMode: .fill)
      }
    }
    .onAppear {
      viewModel.loadImage(from: imageUrlString)
    }
    .onDisappear {
      viewModel.cancelLoad()
      viewModel.cleanImage()
    }
  }
}
