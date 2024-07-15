//
//  UploadNewCakeShopView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import CommonUtil

struct UploadNewCakeShopView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 12) {
        VStack(spacing: 0) {
          SectionHeaderCompact(title: "가게 이름")
          CKTextField(text: .constant(""), placeholder: "가게 이름을 입력해 주세요")
        }
        
        VStack(spacing: 0) {
          SectionHeaderCompact(title: "한 줄 소개")
          CKTextField(text: .constant(""), placeholder: "한 줄 소개를 입력해 주세요")
        }
        
        VStack(spacing: 0) {
          SectionHeaderCompact(title: "샵 설명")
          CKTextField(text: .constant(""), placeholder: "케이크샵 설명을 작성해 주세요", supportsMultiline: true)
        }
      }
      .padding(.horizontal, 28)
    }
  }
}


// MARK: - Preview

#Preview {
  UploadNewCakeShopView()
}
