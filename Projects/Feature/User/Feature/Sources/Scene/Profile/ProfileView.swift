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

public struct ProfileView: View {
  
  // MARK: - Properties
  
  @State private var isLoggedIn = false
  @EnvironmentObject private var router: Router
  @State private var isSignedIn = false
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Views
  
  public var body: some View {
    if isSignedIn {
      ZStack {
        AnimatedGradientBackground(
          backgroundColor: Color(hex: "FEB0CD"),
          gradientColors: [
            Color(hex: "FE85A5"),
            Color(hex: "FE85A5"),
            Color(hex: "FED6C3")
          ])
        
        VStack(spacing: 0) {
          ProfileImageView()
            .zIndex(1)
           
          VStack(spacing: 0) {
            Text("UserName")
              .font(.pretendard(size: 32, weight: .bold))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .frame(maxWidth: .infinity)
              .padding(.horizontal, 28)
              .padding(.top, 84)
            
            HStack(spacing: 24) {
              Button {
                // action
              } label: {
                headerItemButton(title: "가게 등록", icon: DesignSystemAsset.shop.swiftUIImage)
              }
              .modifier(BouncyPressEffect())
              
              Button {
                router.navigate(to: Destination.editProfile)
              } label: {
                headerItemButton(title: "정보 수정", icon: DesignSystemAsset.fileEdit.swiftUIImage)
              }
              .modifier(BouncyPressEffect())
            }
            .padding(.top, 24)
            
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
          router.presentSheet(destination: SheetDestination.login)
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

#if DEBUG
#Preview {
  ProfileView()
}
#endif