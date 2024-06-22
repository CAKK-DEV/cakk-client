//
//  ProfileView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import SwiftUIUtil

import Router

import DomainUser
import UserSession

import DIContainer

public struct ProfileView: View {
  
  // MARK: - Properties
  
  @State private var isLoggedIn = false
  @EnvironmentObject private var router: Router
  
  @StateObject private var viewModel: ProfileViewModel
  @StateObject private var userSession = UserSession.shared
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(ProfileViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    if userSession.isSignedIn {
      ZStack {
        AnimatedGradientBackground(
          backgroundColor: Color(hex: "FEB0CD"),
          gradientColors: [
            Color(hex: "FE85A5"),
            Color(hex: "FE85A5"),
            Color(hex: "FED6C3")
          ])
        .overlay {
          MotionedIconsView()
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, -40)
            .ignoresSafeArea()
        }
        
        VStack(spacing: 0) {
          ProfileImageView(imageUrlString: viewModel.userProfile?.profileImageUrl)
            .zIndex(1)
          
          VStack(spacing: 0) {
            if let nickname = viewModel.userProfile?.nickname {
              Text(nickname)
                .font(.pretendard(size: 32, weight: .bold))
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 84)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            } else {
              RoundedRectangle(cornerRadius: 12)
                .frame(width: 200, height: 28)
                .foregroundStyle(DesignSystemAsset.gray20.swiftUIColor)
                .padding(.top, 84)
            }
            
            HStack(spacing: 24) {
              Button {
                DialogManager.shared.showDialog(
                  title: "케이크 샵 등록 문의",
                  message: "케이크크 문의 채널을 통해서 등록되지 않은 케이크 샵 등록을 요청할 수 있어요.",
                  primaryButtonTitle: "문의 채널로 이동",
                  primaryButtonAction: .custom({
                    if let url = URL(string: "https://www.instagram.com/cakeke_ke?igsh=MWM2ZXN6MjRncHhvbw%3D%3D&utm_source=qr") {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                  }),
                  secondaryButtonTitle: "취소",
                  secondaryButtonAction: .cancel)
              } label: {
                headerItemButton(title: "가게 등록", icon: DesignSystemAsset.shop.swiftUIImage)
              }
              .modifier(BouncyPressEffect())
              
              Button {
                if let userProfile = viewModel.userProfile {
                  router.navigate(to: Destination.editProfile(profile: userProfile))
                } else {
                  DialogManager.shared.showDialog(.pleaseWait(completion: nil))
                }
              } label: {
                headerItemButton(title: "정보 수정", icon: DesignSystemAsset.fileEdit.swiftUIImage)
              }
              .modifier(BouncyPressEffect())
            }
            .padding(.top, 24)
            .disabled(viewModel.userProfileFetchingState == .loading)
            
            ScrollView {
              VStack(spacing: 0) {
                Button("리뷰 남기기") {
                  let url = "https://apps.apple.com/app/6449973946?action=write-review"
                  guard let writeReviewURL = URL(string: url) else { fatalError("Expected a valid URL") }
                  UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                }
                .buttonStyle(ListItemButtonStyle())
                
                Link("피드백 남기기", destination: URL(string: "https://www.instagram.com/cakeke_ke?igsh=MWM2ZXN6MjRncHhvbw%3D%3D&utm_source=qr")!)
                  .buttonStyle(ListItemButtonStyle())
                
                Link("문의하기", destination: URL(string: "https://www.instagram.com/cakeke_ke?igsh=MWM2ZXN6MjRncHhvbw%3D%3D&utm_source=qr")!)
                  .buttonStyle(ListItemButtonStyle())
              }
            }
            .overlay {
              VStack {
                LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom)
                  .frame(height: 20)
                Spacer()
              }
            }
            .padding(.top, 40)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.white)
          .roundedCorner(32, corners: [.topLeft, .topRight])
          .ignoresSafeArea()
          .padding(.top, -64)
        }
        .padding(.top, 56)
      }
      .onAppear {
        viewModel.fetchUserProfile()
      }
    } else {
      VStack(spacing: 0) {
        NavigationBar(centerContent: {
          Text("내 프로필")
            .font(.pretendard(size: 17, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        })
        
        FailureStateView(title: "로그인이 필요한 기능이에요",
                         buttonTitle: "로그인 하고 다양한 기능 누리기",
                         buttonAction: {
          router.presentSheet(destination: UserSheetDestination.login)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  struct ListItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration
        .label
        .font(.pretendard(size: 15, weight: .medium))
        .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 28)
        .background(Color.white)
        .frame(height: 52)
    }
  }
  
  private func headerItemButton(title: String, icon: Image) -> some View {
    VStack(spacing: 12) {
      RoundedRectangle(cornerRadius: 20)
        .fill(DesignSystemAsset.gray10.swiftUIColor)
        .frame(width: 56, height: 56)
        .overlay {
          icon
            .resizable()
            .size(20)
            .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
        }
      
      Text(title)
        .font(.pretendard(size: 12, weight: .bold))
        .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
        .lineLimit(1)
    }
  }
}


// MARK: - Preview

import PreviewSupportUser

// 로그아웃 상태
#Preview {
  UserSession.shared.update(signInState: false)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}


// 일반 유저 로그인 상태
#Preview {
  UserSession.shared.update(signInState: true)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}

// 비즈니스 유저 로그인 상태
#Preview {
  UserSession.shared.update(signInState: true)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .businessOwner)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}
