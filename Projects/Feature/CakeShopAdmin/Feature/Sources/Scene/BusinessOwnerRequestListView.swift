//
//  BusinessOwnerRequestListView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

struct BusinessOwnerRequestListView: View {
  
  // MARK: - Properties
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      FailureStateView(title: "기능 구현 중 입니다..")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("사장님 인증 요청")
  }
}


// MARK: - Preview

#Preview {
  BusinessOwnerRequestListView()
}
