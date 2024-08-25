//
//  ProfileView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DesignSystem
import CommonUtil

import LinkNavigator

import DomainUser
import UserSession

import DIContainer

import AnalyticsService

public struct ProfileView: View {
  
  // MARK: - Properties
  
  @State private var isLoggedIn = false
  
  @StateObject private var profileViewModel: ProfileViewModel
  @StateObject private var businessOwnerProfileViewModel: BusinessOwnerProfileViewModel
  
  @StateObject private var userSession = UserSession.shared
  
  @State private var backgroundIconOffset: CGFloat = 0
  @State private var backgroundIconScale: CGFloat = 1
  
  @State private var animatedGradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let profileViewModel = diContainer.resolve(ProfileViewModel.self)!
    let businessOwnerProfileViewModel = diContainer.resolve(BusinessOwnerProfileViewModel.self)!
    
    _profileViewModel = .init(wrappedValue: profileViewModel)
    _businessOwnerProfileViewModel = .init(wrappedValue: businessOwnerProfileViewModel)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    Group {
      if userSession.isSignedIn {
        ZStack {
          animatedGradientBackground
          .ignoresSafeArea()
          .overlay {
            MotionedIconsView(isMotionActivated: false)
              .frame(maxHeight: .infinity, alignment: .top)
              .padding(.top, -40)
              .offset(y: backgroundIconOffset)
              .scaleEffect(backgroundIconScale)
              .ignoresSafeArea()
          }
          
          ScrollViewOffset { offset in
            backgroundIconOffset = 40 * (1 + offset / 100)
            backgroundIconScale = (1 + (offset / 100) * 0.1)
          } content: {
            VStack(spacing: 0) {
              if profileViewModel.currentRoleState == .user {
                ProfileImageView(imageUrlString: profileViewModel.userProfile?.profileImageUrl)
                  .zIndex(1)
              } else {
                ProfileImageView(imageUrlString: businessOwnerProfileViewModel.cakeShopDetail?.thumbnailImageUrl)
                  .zIndex(1)
              }
              
              VStack(spacing: 0) {
                if let userProfile = profileViewModel.userProfile {
                  VStack(spacing: 8) {
                    if userProfile.role != .user {
                      userRoleChipView(role: profileViewModel.userProfile?.role ?? .user)
                    }
                    
                    Text(profileViewModel.currentRoleState == .user
                         ? userProfile.nickname
                         : businessOwnerProfileViewModel.cakeShopDetail?.shopName ?? "")
                    .font(.pretendard(size: 32, weight: .bold))
                    .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 28)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    
                    if userProfile.role != .user {
                      changeUserRoleButton()
                        .padding(.top, 12)
                    }
                  }
                  .padding(.top, 84)
                } else {
                  /// placeholder
                  RoundedRectangle(cornerRadius: 12)
                    .frame(width: 200, height: 28)
                    .foregroundStyle(DesignSystemAsset.gray20.swiftUIColor)
                    .padding(.top, 84)
                }
                
                if profileViewModel.currentRoleState == .user {
                  HStack(spacing: 24) {
                    Button {
                      navigator?.next(paths: [RouteHelper.SearchMyShop.path], items: [:], isAnimated: true)
                    } label: {
                      headerItemButton(title: "가게 등록", icon: DesignSystemAsset.shop.swiftUIImage)
                    }
                    .modifier(BouncyPressEffect())
                    .opacity(profileViewModel.userProfile?.role != .user ? 0.5 : 1.0)
                    .disabled(profileViewModel.userProfile?.role != .user)
                    
                    Button {
                      navigator?.next(paths: [RouteHelper.EditProfile.path], items: [:], isAnimated: true)
                    } label: {
                      headerItemButton(title: "정보 수정", icon: DesignSystemAsset.fileEdit.swiftUIImage)
                    }
                    .modifier(BouncyPressEffect())
                  }
                  .padding(.top, 24)
                  .disabled(profileViewModel.userProfileFetchingState == .loading)
                }
                
                VStack(spacing: 24) {
                  if profileViewModel.currentRoleState != .user {
                    EditBusinessAccountSection()
                      .environmentObject(businessOwnerProfileViewModel)
                  }
                  
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
                .padding(.top, 40)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color.white)
              .roundedCorner(32, corners: [.topLeft, .topRight])
              .background { /// 하단 빈 공간 채우기 위한 뷰 입니다.
                Color.white
                  .frame(maxWidth: .infinity, minHeight: 1000)
                  .padding(.top, 1000)
              }
              .ignoresSafeArea()
              .padding(.top, -64)
            }
            .padding(.top, 56)
            .padding(.bottom, 100)
          }
          .refreshable {
            profileViewModel.fetchUserProfile()
            businessOwnerProfileViewModel.fetchMyCakeShopId()
          }
        }
        .onFirstAppear {
          profileViewModel.fetchUserProfile()
          businessOwnerProfileViewModel.fetchMyCakeShopId()
        }
      } else {
        VStack(spacing: 0) {
          NavigationBar(centerContent: {
            Text("내 프로필")
              .font(.pretendard(size: 17, weight: .bold))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          })
          
          FailureStateView(title: "로그인이 필요한 기능이에요!",
                           buttonTitle: "로그인하고 다양한 기능 누리기",
                           buttonAction: {
            navigator?.next(paths: [RouteHelper.Login.path], items: [:], isAnimated: true)
          })
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
    .onAppear {
      analytics?.logEngagement(view: self)
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
  
  private func userRoleChipView(role: UserRole) -> some View {
    Text(role.displayName)
      .font(.pretendard(size: 12, weight: .bold))
      .padding(.horizontal, 4)
      .padding(.vertical, 2)
      .foregroundStyle(DesignSystemAsset.brandcolor2.swiftUIColor)
      .background {
        RoundedRectangle(cornerRadius: 5)
          .fill(DesignSystemAsset.brandcolor1.swiftUIColor.opacity(0.3))
      }
  }
  
  private func changeUserRoleButton() -> some View {
    Button {
      switch profileViewModel.currentRoleState {
      case .business:
        profileViewModel.change(role: .user)
      case .user:
        profileViewModel.change(role: .business)
      }
    } label: {
      HStack(spacing: 6) {
        DesignSystemAsset.shuffle.swiftUIImage
          .resizable()
          .size(12)
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        
        switch profileViewModel.currentRoleState {
        case .business:
          Text("일반 회원으로 전환")
            .font(.pretendard(size: 12, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        case .user:
          Text("사장님으로 전환")
            .font(.pretendard(size: 12, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }
      .padding(.horizontal, 15)
      .frame(height: 34)
      .background {
        RoundedRectangle(cornerRadius: 12)
          .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
      }
    }
    .modifier(BouncyPressEffect())
  }
}


// MARK: - Preview

import PreviewSupportUser

#Preview("Logged Out") {
  UserSession.shared.update(signInState: false)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}

#Preview("User") {
  UserSession.shared.update(signInState: true)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .user)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}

#Preview("Business User") {
  UserSession.shared.update(signInState: true)
  let diContainer = DIContainer.shared.container
  diContainer.register(ProfileViewModel.self) { resolver in
    let userProfileUseCase = MockUserProfileUseCase(role: .businessOwner)
    return ProfileViewModel(userProfileUseCase: userProfileUseCase)
  }
  return ProfileView()
}

// TODO: - BusinessOwnerProfileViewModel diContainer 설정 후 프리뷰 수정
