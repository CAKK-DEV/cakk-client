//
//  NewCakeImageView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import UIKit
import DesignSystem
import PhotosUI

import DomainCakeShop

import DIContainer
import Router

public struct NewCakeImageView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: NewCakeImageViewModel
  @EnvironmentObject private var router: Router
  
  @State private var isPhotoPickerShown = false
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(NewCakeImageViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          DialogManager.shared.showDialog(
            title: "저장",
            message: "변경 내용이 저장되지 않았어요.\n그래도 나갈까요?",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              router.navigateBack()
            }),
            secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("사진 등록")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      ScrollView {
        VStack(spacing: 0) {
          Group {
            if let cakeImage = viewModel.cakeImage {
              Image(uiImage: cakeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
              RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .frame(width: 220, height: 280)
                .overlay {
                  RoundedRectangle(cornerRadius: 14)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                    .foregroundStyle(DesignSystemAsset.gray30.swiftUIColor)
                }
                .overlay {
                  VStack {
                    DesignSystemAsset.cakePin.swiftUIImage
                      .resizable()
                      .size(60)
                    
                    Text("클릭 또는 드래그앤 드롭으로\n이미지를 첨부하세요")
                      .font(.pretendard(size: 13))
                      .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                      .multilineTextAlignment(.center)
                  }
                }
            }
          }
          .onTapGesture {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
              DispatchQueue.main.async {
                showPhotosUI(for: state)
              }
            }
          }
          .dropDestination(for: Data.self) { items, location in
            guard let item = items.first else { return false }
            guard let uiImage = UIImage(data: item) else { return false }
            viewModel.updateCake(image: uiImage)
            return true
          }
          
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
          .padding(.top, 28)
          
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
        .padding(.vertical, 28)
        .padding(.bottom, 100)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      VStack {
        CKButtonLarge(title: "등록",
                      fixedSize: 148,
                      action: {
          DialogManager.shared.showDialog(
            title: "업로드",
            message: "정말 이 상태로 업로드 할까요?",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              viewModel.uploadCakeImage()
            }), secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        }, isLoading: .constant(viewModel.imageUploadingState == .loading))
        .padding(.bottom, 16)
        .ignoresSafeArea(.keyboard, edges: .bottom)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .sheet(isPresented: $isPhotoPickerShown) {
      PhotoPicker(selectedImage: $viewModel.cakeImage)
    }
    .onReceive(viewModel.$imageUploadingState, perform: { uploadState in
      switch uploadState {
      case .failure:
        DialogManager.shared.showDialog(.unknownError())
        
      case .emptyImage:
        DialogManager.shared.showDialog(title: "빈 이미지",
                                        message: "이미지가 비어있어요.\n이미지를 선택한 후 다시 시도해주세요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
        
      case .emptyCategory:
        DialogManager.shared.showDialog(title: "빈 카테고리",
                                        message: "카테고리는 최소 1개 이상 선택 되어야해요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(title: "업로드 성공",
                                        message: "업로드에 성공하였어요!",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .custom({
          router.navigateBack()
        }))
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    })
  }
  
  
  // MARK: - Private Methods
  
  private func showPhotosUI(for status: PHAuthorizationStatus) {
    switch status {
    case .notDetermined:
      break
      
    case .restricted, .denied:
      DialogManager.shared.showDialog(
        title: "접근 권한 없음",
        message: "사진첩에 접근할 수 있는 권한이 없어요.\n설정으로 이동해서 사진접 접근 권한을 허용해주세요.",
        primaryButtonTitle: "설정으로 이동",
        primaryButtonAction: .custom({
          guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
          if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
          }
        }),
        secondaryButtonTitle: "취소",
        secondaryButtonAction: .cancel)
      
    case .authorized, .limited:
      isPhotoPickerShown = true
      
    @unknown default:
      break
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(NewCakeImageViewModel.self) { _ in
    let uploadCakeImageUseCase = MockUploadCakeImageUseCase()
    return NewCakeImageViewModel(shopId: 0, uploadCakeImageUseCase: uploadCakeImageUseCase)
  }
  return NewCakeImageView()
}
