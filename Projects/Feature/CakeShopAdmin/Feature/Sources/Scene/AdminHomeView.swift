//
//  AdminHomeView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DIContainer

public struct AdminHomeView: View {
  
  // MARK: - Properties
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    NavigationView {
      SidebarView()
        .navigationTitle("CAKK Admin")
      
      Text("왼쪽의 사이드바를 열어\n페이지를 이동할 수 있어요")
        .foregroundStyle(.gray)
        .multilineTextAlignment(.center)
      
      FailureStateView(title: "페이지가 비어있습니다")
    }
    .tint(.pink)
  }
}


// MARK: - Preview

import PreviewSupportSearch
import PreviewSupportCakeShop
import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopListViewModel.self) { _ in
    let useCase = MockSearchCakeShopUseCase()
    return CakeShopListViewModel(searchCakeShopUseCase: useCase)
  }
  
  diContainer.register(UploadSingleCakeShopViewModel.self) { _ in
    let useCase = MockUploadCakeShopUseCase()
    return UploadSingleCakeShopViewModel(uploadCakeShopUseCase: useCase)
  }
  
  diContainer.register(UploadMultipleCakeShopViewModel.self) { _ in
    let useCase = MockUploadCakeShopUseCase()
    return UploadMultipleCakeShopViewModel(uploadCakeShopUseCase: useCase)
  }
  
  
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
    
    let viewModel = CakeShopDetailViewModel(
      shopId: 0,
      cakeShopDetailUseCase: cakeShopDetailUseCase,
      cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
      cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    viewModel.fetchCakeShopDetail()
    return viewModel
  }
  
  return AdminHomeView()
}
