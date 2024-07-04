//
//  EditCakeImageDetailView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import Kingfisher

import CommonDomain
import DomainCakeShop

import DIContainer
import Router

public struct EditCakeImageDetailView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: EditCakeImageDetailViewModel
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditCakeImageDetailViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          if viewModel.hasChanges() {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "변경 내용이 저장되지 않았어요.\n그래도 나갈까요?",
              primaryButtonTitle: "확인",
              primaryButtonAction: .custom({
                router.navigateBack()
              }),
              secondaryButtonTitle: "취소",
              secondaryButtonAction: .cancel)
          } else {
            router.navigateBack()
          }
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("사진 수정")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }, trailingContent: {
        Button {
          DialogManager.shared.showDialog(
            title: "삭제",
            message: "정말로 이미지를 삭제할까요?\n삭제 후에는 복구가 불가능해요.",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              viewModel.deleteCakeImage()
            }),
            secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        } label: {
          Image(systemName: "trash")
            .font(.system(size: 20))
            .padding(8)
            .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
        }
      })
      
      if let cakeImageDetail = viewModel.cakeImageDetail {
        ScrollView {
          VStack(spacing: 0) {
            KFImage(URL(string: cakeImageDetail.imageUrl))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 220)
              .clipShape(RoundedRectangle(cornerRadius: 16))
          }
          .padding(.top, 28)
          
          VStack(spacing: 8) {
            SectionHeaderCompact(title: "케이크 카테고리 선택")
              .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 12) {
                ForEach(CakeCategory.allCases, id: \.self) { category in
                  let isSelected = viewModel.categories.contains(category)
                  Button {
                    viewModel.toggleCategory(category)
                  } label: {
                    Text(category.displayName)
                      .font(.pretendard(weight: .medium))
                      .foregroundStyle(isSelected ? Color.white : DesignSystemAsset.gray70.swiftUIColor)
                      .padding(.horizontal, 16)
                      .frame(height: 44)
                      .background {
                        RoundedRectangle(cornerRadius: 16)
                          .fill(isSelected ? DesignSystemAsset.gray70.swiftUIColor : DesignSystemAsset.gray10.swiftUIColor)
                      }
                      .overlay {
                        if !isSelected {
                          RoundedRectangle(cornerRadius: 16)
                            .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
                        }
                      }
                  }
                }
              }
              .padding(.horizontal, 24)
            }
          }
          
          VStack(spacing: 8) {
            SectionHeaderCompact(title: "태그 입력")
              .padding(.horizontal, 24)
            
            CKTextField(text: $viewModel.tagString, placeholder: "태그를 입력해 주세요")
              .onSubmit {
                withAnimation(.snappy) {
                  viewModel.addNewTag(tagString: viewModel.tagString)
                }
              }
              .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 12) {
                ForEach(viewModel.tags, id: \.self) { tag in
                  HStack(spacing: 8) {
                    Text(tag)
                      .font(.pretendard(weight: .medium))
                      .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
                      .padding(.leading, 16)
                    
                    Button {
                      withAnimation(.snappy) {
                        viewModel.deleteTag(tagString: tag)
                      }
                    } label: {
                      Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                    }
                    .padding(.trailing, 12)
                  }
                  .frame(height: 44)
                  .contentShape(Rectangle())
                  .background {
                    RoundedRectangle(cornerRadius: 16)
                      .stroke(DesignSystemAsset.gray20.swiftUIColor, lineWidth: 1)
                  }
                }
              }
              .padding(.vertical, 12)
              .padding(.horizontal, 24)
            }
          }
          .padding(.top, 20)
        }
        .padding(.bottom, 100)
      } else {
        if viewModel.cakeImageDetailFetchingState == .loading {
          VStack {
            ProgressView()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          FailureStateView(title: "불러오기에 실패하였어요")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      VStack {
        CKButtonLarge(title: "저장",
                      fixedSize: 148,
                      action: {
          DialogManager.shared.showDialog(
            title: "저장",
            message: "정말 이 상태로 수정 할까요?",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              viewModel.updateCakeImage()
            }), secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        }, isLoading: .constant(viewModel.cakeImageUpdatingState == .loading))
        .padding(.bottom, 16)
        .ignoresSafeArea(.keyboard, edges: .bottom)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onReceive(viewModel.$cakeImageUpdatingState, perform: { updatingState in
      switch updatingState {
      case .failure:
        DialogManager.shared.showDialog(.unknownError())
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(title: "업데이트 성공",
                                        message: "업데이트 성공하였어요!",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .custom({
          router.navigateBack()
        }))
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    })
    .onReceive(viewModel.$cakeImageDeletingState, perform: { deletingState in
      switch deletingState {
      case .failure:
        DialogManager.shared.showDialog(.unknownError())
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        router.navigateBack()
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    })
    .onFirstAppear {
      viewModel.fetchImageDetail()
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditCakeImageDetailViewModel.self) { _ in
    let cakeImageDetailUseCase = MockCakeImageDetailUseCase()
    let editCakeImageUseCase = MockEditCakeImageUseCase()
    let deleteCakeImageUseCase = MockDeleteCakeImageUseCase()
    return EditCakeImageDetailViewModel(cakeImageId: 0,
                                        cakeImageDetailUseCase: cakeImageDetailUseCase,
                                        editCakeImageUseCase: editCakeImageUseCase,
                                        deleteCakeImageUseCase: deleteCakeImageUseCase)
  }
  return EditCakeImageDetailView()
}
