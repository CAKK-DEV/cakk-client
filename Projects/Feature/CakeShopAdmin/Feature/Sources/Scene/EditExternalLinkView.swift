//
//  EditExternalLinkView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DomainCakeShop

import DIContainer
import Router

struct EditExternalLinkView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: EditExternalLinkViewModel
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditExternalLinkViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          if viewModel.hasChanges() {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "저장되지 않은 내용이 있어요.\n내용을 저장하지 않고 나갈까요??",
              primaryButtonTitle: "네",
              primaryButtonAction: .custom({
                router.navigateBack()
              }),
              secondaryButtonTitle: "머무르기", secondaryButtonAction: .cancel)
          } else {
            router.navigateBack()
          }
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("외부 링크 수정")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      ScrollView {
        VStack(spacing: 20) {
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "인스타그램")
            CKTextField(text: $viewModel.instaUrl, placeholder: "인스타그램 주소를 입력해주세요")
              .ignoresSafeArea(.keyboard)
          }
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "카카오 채널")
            CKTextField(text: $viewModel.kakaoUrl, placeholder: "카카오 채널 주소를 입력해주세요")
              .ignoresSafeArea(.keyboard)
          }
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "웹사이트")
            CKTextField(text: $viewModel.webUrl, placeholder: "웹 사이트 주소를 입력해주세요")
              .ignoresSafeArea(.keyboard)
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 200)
      }
      .overlay {
        VStack {
          CKButtonLarge(title: "저장", fixedSize: .infinity) {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "정말 이 상태로 저장할까요?",
              primaryButtonTitle: "확인",
              primaryButtonAction: .custom({
                viewModel.updateExternLinks()
              }),
              secondaryButtonTitle: "취소",
              secondaryButtonAction: .cancel)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.vertical, 16)
        .padding(.horizontal, 28)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .onReceive(viewModel.$updatingState) { newState in
      switch newState {
      case .failure:
        DialogManager.shared.showDialog(
          title: "정보 업데이트 실패",
          message: "외부 링크 업데이트에 실패하였어요\n다시 시도해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .invalidUrl:
        DialogManager.shared.showDialog(
          title: "옳바르지 않은 주소",
          message: "주소 형식이 올바르지 않아요.\n주소가 올바른지 확인해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(
          title: "업데이트 성공",
          message: "외부 링크 업데이트에 성공하였어요",
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

import PreviewSupportCakeShopAdmin

#Preview("Success") {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditExternalLinkViewModel.self) { _ in
    let useCase = MockEditExternalLinkUseCase()
    return EditExternalLinkViewModel(
      shopId: 0,
      editExternalLinkUseCase: useCase,
      externalShopLinks: [
        .init(linkType: .instagram, linkPath: "https://instangra/profile/cakk")
      ])
  }
  return EditExternalLinkView()
}

#Preview("Failure") {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditExternalLinkViewModel.self) { _ in
    let useCase = MockEditExternalLinkUseCase(scenario: .failure)
    return EditExternalLinkViewModel(
      shopId: 0,
      editExternalLinkUseCase: useCase,
      externalShopLinks: [
        .init(linkType: .instagram, linkPath: "https://instangra/profile/cakk")
      ])
  }
  return EditExternalLinkView()
}
