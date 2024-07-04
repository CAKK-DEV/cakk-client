//
//  UploadMultipleCakeShopView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DIContainer

struct UploadMultipleCakeShopView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: UploadMultipleCakeShopViewModel
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(UploadMultipleCakeShopViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      TextField("raw json을 넣어주세요.", text: $viewModel.jsonRawString, axis: .vertical)
        .padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(DesignSystemAsset.gray10.swiftUIColor)
        .cornerRadius(10)
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("다중 등록")
    .toolbar {
      Button("등록") {
        viewModel.upload()
      }
    }
    .onChange(of: viewModel.cakeShopUploadingState) { newState in
      switch newState {
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .failure:
        DialogManager.shared.showDialog(
          title: "업로드 실패",
          message: "업로드에 실패하였습니다.\n데이터 또는 인터넷 환경을 다시 확인해 주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .jsonParsingFailure:
        DialogManager.shared.showDialog(
          title: "Json 파싱 실패",
          message: "유효하지 않는 Json 형식입니다.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .success:
        DialogManager.shared.showDialog(
          title: "업로드 성공",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    }
  }
}


// MARK: - Preview

#Preview {
  NavigationSplitView {
    EmptyView()
  } detail: {
    UploadMultipleCakeShopView()
  }
}
