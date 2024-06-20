//
//  EditProfileView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import PhotosUI

import SwiftUIUtil
import UIKitUtil

import Router

import DomainUser

import DIContainer

struct EditProfileView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: EditProfileViewModel
  @StateObject private var profileViewModel: ProfileViewModel
  @EnvironmentObject private var router: Router
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var isPhotoPickerShown = false
  @State private var isProfileImageOptionActionSheetShown = false
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditProfileViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    let profileViewModel = diContainer.resolve(ProfileViewModel.self)!
    _profileViewModel = .init(wrappedValue: profileViewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          if viewModel.profileHasChanges() {
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
            .frame(width: 40, height: 40)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("회원 정보 수정")
          .font(.pretendard(size: 17, weight: .semiBold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      ZStack(alignment: .bottom) {
        ScrollView {
          VStack(spacing: 20) {
            /// profileImage가 delete 이면 현재 프로필 사진을 삭제하겠다는 의미이므로 보여지는 뷰도 기본 이미지로 보여줘야합니다.
            let imageUrl = viewModel.editedUserProfile.profileImage == .delete ? nil : viewModel.originalUserProfile.profileImageUrl
            
            ProfileImageView(imageUrlString: imageUrl)
              .overlay {
                /// 새로운 이미지를 라이브러리에서 선택했다면 새로운 이미지를 overlay로 보여줍니다.
                /// ProfileImageView에 새로운 이미지를 직접 주입하지 않는 이유는 이 방식이 프로필 이미지를 다시 제거했을 때 등 다양한 상황에 대처하기 좋기 때문입니다.
                if case .new(let newProfileImage) = viewModel.editedUserProfile.profileImage {
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
                      if case .new(_) = viewModel.editedUserProfile.profileImage {
                        Button("기존 사진으로 변경") {
                          if let originalProfileImageUrl = viewModel.originalUserProfile.profileImageUrl {
                            viewModel.editedUserProfile.profileImage = .original(imageUrl: originalProfileImageUrl)
                          }
                        }
                      }
                      
                      /// 새로운 프로필 사진을 등록했거나 기존 프로필 사진이 있을 때에만 "삭제" 버튼 표시
                      if viewModel.editedUserProfile.profileImage != .none
                          && viewModel.editedUserProfile.profileImage != .delete {
                        Button("삭제", role: .destructive) {
                          viewModel.editedUserProfile.profileImage = .delete
                        }
                      }
                    }.sheet(isPresented: $isPhotoPickerShown) {
                      PhotoPicker(selectedImage: .init(get: {
                        if case .new(let image) = viewModel.editedUserProfile.profileImage {
                          return image
                        } else {
                          return nil
                        }
                      }, set: { image in
                        if let image {
                          viewModel.editedUserProfile.profileImage = .new(image: image)
                        }
                      }))
                    }
                  }
                }
              }
              .padding(.top, 20)
            
            CKTextField(text: $viewModel.editedUserProfile.nickname, placeholder: "이름", headerTitle: "이름")
            
            CKTextField(text: $viewModel.editedUserProfile.email, headerTitle: "이메일", isDisabled: true)
            
            genderPicker()
            birthdaySelector()
            
            HStack(spacing: 0) {
              Button("로그아웃") {
                DialogManager.shared.showDialog(
                  title: "로그아웃",
                  message: "정말로 로그아웃 할까요?",
                  primaryButtonTitle: "확인",
                  primaryButtonAction: .custom({
                    viewModel.signOut()
                    router.navigateBack()
                  }), secondaryButtonTitle: "취소",
                  secondaryButtonAction: .cancel)
              }
              .font(.pretendard(size: 15, weight: .medium))
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              
              Button("회원탈퇴") {
                DialogManager.shared.showDialog(
                  title: "회원탈퇴",
                  message: "정말로 회원탈퇴 하시겠습니까?\n회원탈퇴를 하시면 모든 데이터가 삭제되며 복구할 수 없게돼요.",
                  primaryButtonTitle: "확인",
                  primaryButtonAction: .custom({
                    viewModel.withdraw()
                  }), secondaryButtonTitle: "취소",
                  secondaryButtonAction: .cancel)
              }
              .font(.pretendard(size: 15, weight: .medium))
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .onChange(of: viewModel.withdrawState) { state in
                switch state {
                case .loading:
                  LoadingManager.shared.startLoading()
                case .failure(let error):
                  LoadingManager.shared.stopLoading()
                  
                  if error == .serverError {
                    DialogManager.shared.showDialog(.serverError(completion: nil))
                  } else {
                    DialogManager.shared.showDialog(
                      title: "회원탈퇴 실패",
                      message: "회원탈퇴에 실패하였어요..\n다시 시도해 주세요.",
                      primaryButtonTitle: "확인",
                      primaryButtonAction: .cancel)
                  }
                case .success:
                  LoadingManager.shared.stopLoading()
                  router.navigateBack()
                default:
                  LoadingManager.shared.stopLoading()
                }
              }
            }
            .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
            .padding(.top, 128)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 24)
          .padding(.bottom, 100)
        }
        
        VStack(spacing: 0) {
          CKButtonLarge(title: "저장",
                        fixedSize: .infinity,
                        action: {
            if viewModel.isNicknameValid() {
              viewModel.updateProfile()
            } else {
              DialogManager.shared.showDialog(
                title: "올바르지 않은 이름",
                message: "이름에는 소문자, 대문자, 한글, 숫자, 언더바만 사용할 수 있어요.",
                primaryButtonTitle: "확인",
                primaryButtonAction: .cancel)
            }
          }, isLoading: .constant(viewModel.userProfileUpdatingState == .loading))
          .padding(.horizontal, 28)
          .padding(.bottom, 16)
          .opacity(viewModel.profileHasChanges() ? 1.0 : 0.3)
          .disabled(!viewModel.profileHasChanges())
          .animation(.snappy, value: viewModel.profileHasChanges())
          .onChange(of: viewModel.userProfileUpdatingState) { state in
            switch state {
            case .success:
              router.navigateBack()
              /// 기존 프로필 업데이트
              profileViewModel.fetchUserProfile()
              LoadingManager.shared.stopLoading()
            case .loading:
              LoadingManager.shared.startLoading()
            case .failure(let error):
              LoadingManager.shared.stopLoading()
              if error == .serverError {
                DialogManager.shared.showDialog(.serverError(completion: nil))
              } else {
                DialogManager.shared.showDialog(
                  title: "프로필 업데이트 실패",
                  message: "프로필 업데이트에 하였어요.\n다시 시도해주세요.",
                  primaryButtonTitle: "확인",
                  primaryButtonAction: .cancel)
              }
            default:
              LoadingManager.shared.stopLoading()
            }
          }
        }
        .background {
          LinearGradient(colors: [.clear, .white, .white],
                         startPoint: .top,
                         endPoint: .bottom)
          .ignoresSafeArea()
        }
      }
    }
  }
  
  private func genderPicker() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "성별")
      
      HStack(spacing: 20) {
        Text(viewModel.editedUserProfile.gender.displayName)
          .font(.pretendard(size: 15, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Image(systemName: "chevron.down")
          .font(.system(size: 20))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }
      .overlay {
        HStack {
          Spacer()
          
          Picker("성별", selection: $viewModel.editedUserProfile.gender) {
            ForEach(Gender.allCases, id: \.self) { gender in
              Button {
                viewModel.editedUserProfile.gender = gender
              } label: {
                Text(gender.displayName)
                Image(uiImage: UIImage.generated(fromEmoji: gender.emoji, fontSize: 17)!)
              }
            }
          }
          .opacity(0.011)
        }
      }
      .frame(height: 52)
      .padding(.horizontal, 4)
    }
  }
  
  private func birthdaySelector() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "생년월일")
      Text(viewModel.editedUserProfile.birthday?.formatted(.dateTime.day().month().year()) ?? "설정된 생일 없음")
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 52)
        .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
        .overlay {
          if viewModel.editedUserProfile.birthday != nil {
            HStack {
              DatePicker(selection: $viewModel.editedUserProfile.birthday ?? .now, in: ...Date(), displayedComponents: .date) {}
                .labelsHidden()
                .contentShape(Rectangle())
                .opacity(0.011)
              Spacer()
            }
          }
        }
    }
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

import PreviewSupportUser

// 프로필 업데이트 성공 시나리오

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditProfileViewModel.self) { resolver in
    let profileUseCase = MockUserProfileUseCase(role: .user)
    let updateUserProfileUseCase = MockUpdateUserProfileUseCase()
    let withdrawUseCase = MockWithdrawUseCase()
    return EditProfileViewModel(userProfile: UserProfile.makeMockUserProfile(role: .user),
                                updateUserProfileUseCase: updateUserProfileUseCase,
                                withdrawUseCase: withdrawUseCase)
  }
  return EditProfileView()
}


// 프로필 업데이트 실패 시나리오

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditProfileViewModel.self) { resolver in
    let profileUseCase = MockUserProfileUseCase(role: .user)
    let updateUserProfileUseCase = MockUpdateUserProfileUseCase(scenario: .failure)
    let withdrawUseCase = MockWithdrawUseCase()
    return EditProfileViewModel(userProfile: UserProfile.makeMockUserProfile(role: .user),
                                updateUserProfileUseCase: updateUserProfileUseCase,
                                withdrawUseCase: withdrawUseCase)
  }
  return EditProfileView()
}
