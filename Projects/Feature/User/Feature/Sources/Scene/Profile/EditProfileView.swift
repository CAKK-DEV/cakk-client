//
//  EditProfileView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import SwiftUIUtil
import UIKitUtil
import Router

import DomainUser

import DIContainer

struct EditProfileView: View {
  
  // MARK: - Properties

  @StateObject private var viewModel: ProfileViewModel
  @EnvironmentObject private var router: Router
  
  @Environment(\.dismiss) private var dismiss
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(ProfileViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
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
                viewModel.restoreChanges()
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
      
      if viewModel.userProfile == nil {
        ScrollView { }
          .overlay {
            ProgressView()
          }
          .onAppear {
            // 만약 사용자 정보가 없다면 다시 불러옴.
            viewModel.fetchUserProfile()
          }
      } else {
        ZStack(alignment: .bottom) {
          ScrollView {
            VStack(spacing: 20) {
              ProfileImageView(imageUrlString: viewModel.editedUserProfile.profileImageUrl)
                .overlay {
                  HStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                      Spacer()
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
                  }
                }
                .padding(.top, 20)
              
              CKTextField(text: $viewModel.editedUserProfile.nickname, placeholder: "이름", headerTitle: "이름")
              CKTextField(text: $viewModel.editedUserProfile.email, headerTitle: "이메일", isDisabled: true)
              
              genderPicker()
              birthdaySelector()
              
              HStack(spacing: 0) {
                Button("로그아웃") {
                  // no action
                }
                .font(.pretendard(size: 15, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                
                Button("회원탈퇴") {
                  // no action
                }
                .font(.pretendard(size: 15, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
              }
              .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
              .padding(.top, 128)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
          }
          
          VStack(spacing: 0) {
            CKButtonLarge(title: "저장", 
                          fixedSize: .infinity,
                          action: {
              viewModel.updateProfile()
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
                LoadingManager.shared.stopLoading()
              case .loading:
                LoadingManager.shared.startLoading()
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
}


// MARK: - Preview

import PreviewSupportUser

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let profileUseCase = MockUserProfileUseCase(role: .user)
    let updateUserProfileUseCase = MockUpdateUserProfileUseCase()
    return ProfileViewModel(userProfileUseCase: profileUseCase,
                            updateUserProfileUseCase: updateUserProfileUseCase)
  }
  return EditProfileView()
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}
