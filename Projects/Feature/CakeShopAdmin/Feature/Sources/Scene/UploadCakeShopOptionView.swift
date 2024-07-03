//
//  UploadCakeShopOptionView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DIContainer

struct UploadCakeShopOptionView: View {
  
  // MARK: - Properties
  
  @Environment(\.dismiss) private var dismiss
  
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    List {
      NavigationLink(destination: UploadSingleCakeShopView()) {
        Text("단일 등록")
      }
      
      NavigationLink(destination: UploadMultipleCakeShopView()) {
        Text("다중 등록")
      }
    }
    .listStyle(.inset)
    .navigationTitle("가게 등록")
  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(UploadSingleCakeShopViewModel.self) { _ in
    let useCase = MockUploadCakeShopUseCase()
    return UploadSingleCakeShopViewModel(uploadCakeShopUseCase: useCase)
  }
  
  diContainer.register(UploadMultipleCakeShopViewModel.self) { _ in
    let useCase = MockUploadCakeShopUseCase()
    return UploadMultipleCakeShopViewModel(uploadCakeShopUseCase: useCase)
  }
  
  return UploadCakeShopOptionView()
}


