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

import CommonUtil
import CommonUtil

import LinkNavigator

import DomainUser

import DIContainer

import AnalyticsService

struct EditProfileView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: EditProfileViewModel
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var isPhotoPickerShown = false
  @State private var isProfileImageOptionActionSheetShown = false
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditProfileViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
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
                navigator?.back(isAnimated: true)
              }),
              secondaryButtonTitle: "머무르기", secondaryButtonAction: .cancel)
          } else {
            navigator?.back(isAnimated: true)
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
      
      if viewModel.userProfileFetchingState == .success {
        editProfileView()
      } else {
        VStack {
          ProgressView()
        }
        .frame(maxHeight: .infinity)
      }
    }
    .onAppear {
      viewModel.fetchUserProfile()
      analytics?.logEngagement(view: self)
    }
    .onReceive(viewModel.$userProfileFetchingState) { state in
      switch state {
      case .failure(let error):
        if error == .serverError {
          DialogManager.shared.showDialog(.serverError(completion: {
            navigator?.back(isAnimated: true)
          }))
        } else if error == .sessionExpired {
          DialogManager.shared.showDialog(
            title: "로그인 세션 만료",
            message: "로그인 세션이 만료 되었기 때문에 프로필을 편집할 수 없어요. 로그인 후 다시 시도해 주세요.",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              navigator?.back(isAnimated: true)
            }))
        } else {
          DialogManager.shared.showDialog(.unknownError(completion: {
            navigator?.back(isAnimated: true)
          }))
        }
      default:
        break
      }
    }
  }
  
  private func editProfileView() -> some View {
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
                    .ignoresSafeArea()
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
                }), secondaryButtonTitle: "취소",
                secondaryButtonAction: .cancel)
            }
            .font(.pretendard(size: 15, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .onReceive(viewModel.$signOutState, perform: { newState in
              switch newState {
              case .failure:
                DialogManager.shared.showDialog(
                  title: "로그아웃 실패",
                  message: "로그아웃에 실패하였어요..\n다시 시도해 주세요.",
                  primaryButtonTitle: "확인",
                  primaryButtonAction: .cancel)
              case .success:
                navigator?.back(isAnimated: true)
              default:
                break
              }
            })
            
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
                navigator?.back(isAnimated: true)
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
        LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
          .frame(height: 24)
        
        CKButtonLarge(title: "저장",
                      fixedSize: .infinity,
                      action: {
          if viewModel.isNicknameValid() {
            viewModel.updateProfile()
          } else {
            DialogManager.shared.showDialog(
              title: "올바르지 않은 이름",
              message: "이름은 20자 이하, 소문자, 대문자, 한글, 숫자, 언더바만 사용할 수 있어요.",
              primaryButtonTitle: "확인",
              primaryButtonAction: .cancel)
          }
        }, isLoading: .constant(viewModel.userProfileUpdatingState == .loading))
        .padding(.horizontal, 28)
        .padding(.bottom, 16)
        .opacity(viewModel.profileHasChanges() ? 1.0 : 0.3)
        .background(Color.white)
        .disabled(!viewModel.profileHasChanges())
        .animation(.snappy, value: viewModel.profileHasChanges())
        .onChange(of: viewModel.userProfileUpdatingState) { state in
          switch state {
          case .success:
            navigator?.back(isAnimated: true)
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

#Preview("Success") {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    let updateUserProfileUseCase = MockUpdateUserProfileUseCase()
    let signOutUseCase = MockSocialLoginSignOutUseCase()
    let withdrawUseCase = MockWithdrawUseCase()
    return EditProfileViewModel(userProfileUseCase: userProfileUseCase,
                                updateUserProfileUseCase: updateUserProfileUseCase,
                                signOutUseCase: signOutUseCase,
                                withdrawUseCase: withdrawUseCase)
  }
  return EditProfileView()
}

#Preview("Failure") {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    let updateUserProfileUseCase = MockUpdateUserProfileUseCase(scenario: .failure)
    let signOutUseCase = MockSocialLoginSignOutUseCase(scenario: .failure)
    let withdrawUseCase = MockWithdrawUseCase()
    return EditProfileViewModel(userProfileUseCase: userProfileUseCase,
                                updateUserProfileUseCase: updateUserProfileUseCase,
                                signOutUseCase: signOutUseCase,
                                withdrawUseCase: withdrawUseCase)
  }
  return EditProfileView()
}
