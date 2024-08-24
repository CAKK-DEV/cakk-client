//
//  EditCakeShopBasicInfoView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem
import PhotosUI

import DomainCakeShop

import DIContainer
import LinkNavigator

public struct EditCakeShopBasicInfoView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: EditCakeShopBasicInfoViewModel
  
  @State private var isPhotoPickerShown = false
  @State private var isProfileImageOptionActionSheetShown = false
  
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditCakeShopBasicInfoViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar{
        Button {
          if viewModel.basicInfoHasChanges() {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "저장되지 않은 내용이 있어요.\n내용을 저장하지 않고 나갈까요??",
              primaryButtonTitle: "네",
              primaryButtonAction: .custom({
                navigator?.back(isAnimated: true)
              }),
              secondaryButtonTitle: "머무르기", secondaryButtonAction: .cancel)
          } else {
            navigator?.back(isAnimated: true)
          }
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .padding(8)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      } centerContent: {
        Text("기본 정보")
          .font(.pretendard(size: 17, weight: .semiBold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }
      
      if viewModel.cakeShopDetailFetchingState == .success {
        editBasicInfoView()
      } else {
        VStack {
          ProgressView()
        }
        .frame(maxHeight: .infinity)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      if viewModel.cakeShopDetailFetchingState == .success {
        VStack {
          Spacer()
          VStack(spacing: 0) {
            LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
              .frame(height: 20)
            
            CKButtonLarge(title: "저장",
                          fixedSize: .infinity,
                          action: {
              DialogManager.shared.showDialog(
                title: "저장",
                message: "정말 이 상태로 저장할까요?",
                primaryButtonTitle: "확인",
                primaryButtonAction: .custom({
                  viewModel.updateShopBasicInfo()
                }),
                secondaryButtonTitle: "취소",
                secondaryButtonAction: .cancel)
            }, isLoading: .constant(viewModel.basicInfoUpdatingState == .loading))
            .padding(.horizontal, 28)
            .padding(.bottom, 16)
          }
        }
      }
    }
    .onAppear {
      viewModel.fetchCakeShopDetail()
    }
    .onChange(of: viewModel.basicInfoUpdatingState) { newState in
      switch newState {
      case .failure:
        DialogManager.shared.showDialog(
          title: "정보 업데이트 실패",
          message: "가게 정보 업데이트에 실패하였어요\n다시 시도해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(
          title: "업데이트 성공",
          message: "가게 정보 업데이트에 성공하였어요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .custom({
            navigator?.back(isAnimated: true)
          }))
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    }
    .onReceive(viewModel.$cakeShopDetailFetchingState) { state in
      switch state {
      case .failure(let error):
        if error == .noExists {
          DialogManager.shared.showDialog(title: "",
                                          primaryButtonTitle: "확인",
                                          primaryButtonAction: .custom({
            navigator?.back(isAnimated: true)
          }))
        } else {
          
        }
      default:
        break
      }
    }
  }
  
  private func editBasicInfoView() -> some View {
    ScrollView {
      VStack(spacing: 20) {
        profileImageView()
        
        VStack {
          SectionHeaderCompact(title: "케이크샵 이름")
          CKTextField(text: $viewModel.editedBasicInfo.shopName, placeholder: "케이크샵 이름을 입력하세요")
        }
        
        VStack {
          SectionHeaderCompact(title: "가게 한 줄 소개")
          CKTextField(text: $viewModel.editedBasicInfo.shopBio, placeholder: "가게 한 줄 소개를 작성해주세요", supportsMultiline: true)
        }
        
        VStack {
          SectionHeaderCompact(title: "가게 정보")
          CKTextField(text: $viewModel.editedBasicInfo.shopDescription, placeholder: "가게 정보를 입력해주세요", supportsMultiline: true)
        }
      }
      .padding(.horizontal, 24)
      .padding(.top, 20)
      .padding(.bottom, 200)
    }
  }
  
  private func profileImageView() -> some View {
    ProfileImageView(imageUrlString: viewModel.originalCakeShopDetail.thumbnailImageUrl)
      .overlay {
        /// 새로운 이미지를 라이브러리에서 선택했다면 새로운 이미지를 overlay로 보여줍니다.
        /// ProfileImageView에 새로운 이미지를 직접 주입하지 않는 이유는 이 방식이 프로필 이미지를 다시 제거했을 때 등 다양한 상황에 대처하기 좋기 때문입니다.
        if case .new(let newProfileImage) = viewModel.editedBasicInfo.profileImage {
          Image(uiImage: newProfileImage)
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 122, height: 122)
        }
      }
      .overlay {
        HStack(spacing: 0) {
          Spacer()
          VStack(spacing: 0) {
            Spacer()
            
            Button {
              isProfileImageOptionActionSheetShown = true
            } label: {
              Circle()
                .fill(DesignSystemAsset.gray70.swiftUIColor)
                .size(36)
                .overlay {
                  DesignSystemAsset.camera.swiftUIImage
                    .resizable()
                    .size(16)
                    .foregroundStyle(Color.white)
                }
            }
            .modifier(BouncyPressEffect())
            .confirmationDialog("프로필 사진", isPresented: $isProfileImageOptionActionSheetShown) {
              Button("라이브러리에서 선택") {
                /// 라이브러리 접근 권한을 먼저 요청한 후 상황에 맞는 View를 띄워줍니다.
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
                  DispatchQueue.main.async {
                    showPhotosUI(for: state)
                  }
                }
              }
              
              /// 프로필 사진을 새로운 사진으로 할당했을 때에만 "기존 사진으로 변경" 버튼 표시
              if case .new(_) = viewModel.editedBasicInfo.profileImage {
                Button("기존 사진으로 변경") {
                  if let originalProfileImageUrl = viewModel.originalCakeShopDetail.thumbnailImageUrl {
                    viewModel.editedBasicInfo.profileImage = .original(imageUrl: originalProfileImageUrl)
                  }
                }
              }
              
              /// 새로운 프로필 사진을 등록했거나 기존 프로필 사진이 있을 때에만 "삭제" 버튼 표시
              if viewModel.editedBasicInfo.profileImage != .none
                  && viewModel.editedBasicInfo.profileImage != .delete {
                Button("삭제", role: .destructive) {
                  viewModel.editedBasicInfo.profileImage = .delete
                }
              }
            }.sheet(isPresented: $isPhotoPickerShown) {
              PhotoPicker(selectedImage: .init(get: {
                if case .new(let image) = viewModel.editedBasicInfo.profileImage {
                  return image
                } else {
                  return nil
                }
              }, set: { image in
                if let image {
                  viewModel.editedBasicInfo.profileImage = .new(image: image)
                }
              }))
              .ignoresSafeArea()
            }
          }
        }
      }
      .dropDestination(for: Data.self) { items, location in
        guard let item = items.first else { return false }
        guard let uiImage = UIImage(data: item) else { return false }
        viewModel.editedBasicInfo.profileImage = .new(image: uiImage)
        return true
      }
  }
  
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
import PreviewSupportCakeShop

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditCakeShopBasicInfoViewModel.self) { _ in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let editShopBasicInfoUseCase = MockEditShopBasicInfoUseCase()
    return EditCakeShopBasicInfoViewModel(
      shopId: 1,
      cakeShopDetailUseCase: cakeShopDetailUseCase,
      editShopBasicInfoUseCase: editShopBasicInfoUseCase
    )
  }
  return EditCakeShopBasicInfoView()
}
